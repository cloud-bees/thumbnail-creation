import uuid
from urllib.parse import unquote_plus

import boto3
from PIL import Image

s3_client = boto3.client("s3")
dynamodb_client = boto3.client("dynamodb")


def resize_image(image_path, resized_path):
  with Image.open(image_path) as image:
    image.thumbnail(tuple(x / 2 for x in image.size))
    image.save(resized_path)


def save_metadata_to_dynamodb(bucket: str, key: str, object_metadata: dict):
  table_name = f"{bucket}-thumbnail-metadata"
  item = {
    "origin_object": {"S": key},
    "thumbnail_object": {"S": f"resized-{key}"},
    "origin_bucket": {"S": bucket},
    "thumbnail_bucket": {"S": f"{bucket}-thumbnail"},
    "last_modified": {"S": str(object_metadata["LastModified"])},
  }
  response = dynamodb_client.put_item(TableName=table_name, Item=item)
  print(response)


def lambda_handler(event, context):
  for record in event["Records"]:
    bucket = record["s3"]["bucket"]["name"]
    key = unquote_plus(record["s3"]["object"]["key"])

    if key.split(".")[-1] not in ["jpg", "png"]:
      raise TypeError("Invalid file type. Please upload a jpg/png file.")

    tmp_key = key.replace("/", "")
    download_path = "/tmp/{}{}".format(uuid.uuid4(), tmp_key)
    upload_path = "/tmp/resized-{}".format(tmp_key)
    s3_client.download_file(bucket, key, download_path)

    resize_image(download_path, upload_path)
    s3_client.upload_file(
      upload_path, "{}-thumbnail".format(bucket), "resized-{}".format(key)
    )
    object_metadata = s3_client.get_object(Bucket=bucket, Key=key)
    save_metadata_to_dynamodb(bucket, key, object_metadata)

#!/bin/zsh

# Get script directory
# SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

SCR_DIR=$ROOT_DIR/src

# Compress the package
file_name=$(basename $TF_VAR_lambda_file)
pushd $SCR_DIR/package
zip -r ../$file_name .
pushd $SCR_DIR
zip $file_name lambda.py
popd
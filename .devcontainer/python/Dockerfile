FROM continuumio/miniconda3:23.10.0-1 AS conda

# Do nothing, just get miniconda image

FROM ubuntu:22.04

# hadolint ignore=DL3008
RUN apt-get update && apt-get install wget curl ca-certificates -y --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

COPY --from=conda /opt/conda /opt/conda

ENV PATH=/opt/conda/bin:$PATH
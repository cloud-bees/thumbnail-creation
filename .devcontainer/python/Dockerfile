FROM ubuntu:22.04

ARG CONDA_INSTALL
ARG tmp_conda=/tmp/miniconda.sh
ENV CONDA_INSTALL=${CONDA_INSTALL:-/opt/conda}

# hadolint ignore=DL3008
RUN apt-get update && apt-get install wget curl -y --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

RUN <<EOF
  arch=$(uname -m)
  if [ "$arch" = "x86_64" ]; then
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh";
  elif [ "$arch" = "aarch64" ]; then
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh";
  else
    echo "Unsupported architecture: $arch";
    exit 1;
  fi
  wget $MINICONDA_URL -O $tmp_conda -q
EOF

RUN bash $tmp_conda -b -p $CONDA_INSTALL \
  && chmod a+w -R $CONDA_INSTALL \
  && rm -f $tmp_conda
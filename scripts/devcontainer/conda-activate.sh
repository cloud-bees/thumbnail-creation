#!/bin/zsh

conda init --all

conda create -n py$PYTHON_VERSION python=$PYTHON_VERSION -y
echo "conda activate py$PYTHON_VERSION" >> ~/.zshrc

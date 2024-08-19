#!/bin/zsh

# Get script directory
# SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

package_dir=$ROOT_DIR/src/package
mkdir -p $package_dir

pip install \
--platform manylinux2014_$(uname -m) \
--target $package_dir \
--implementation cp \
--python-version $PYTHON_VERSION \
--only-binary=:all: --upgrade \
-r $ROOT_DIR/src/requirements.txt

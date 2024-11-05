#!/bin/bash
# Copyright 2024 The MathWorks, Inc.

DEFAULT_DOWNLOAD_BASE_URL='https://ssd.mathworks.com/supportfiles/ci/matlab-batch/v1'
DEFAULT_UNIX_INSTALL_LOCATION='/opt/mathworks'
DEFAULT_WIN_INSTALL_LOCATION='C:\Program Files\MathWorks'

# Exit on any failure, treat unset substitution variables as errors
set -euo pipefail   

# Function to display help message
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h    Display this help message."
    echo "  -i    Specify an install location."
}

# Initialize our own variables:
input_value=""

# Process command-line options

OPTSTRING=":hi:"

while getopts "$OPTSTRING" opt; do
    case ${opt} in
        h)
            show_help
            exit 0
            ;;
        i)
            input_value=$OPTARG
            ;;
        \?)
            echo "Invalid option: -${OPTARG}" 1>&2
            show_help
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." 1>&2
            exit 1
            ;;
    esac
done

# Use the input value if provided
if [ -n "$input_value" ]; then
  install_dir=$input_value
else
    echo "Using default install location."
fi

# Function to download the matlab-batch executable binary
download() {
  url=$1
  filename=$2

  if [ -x "$(command -v wget)" ]; then
    wget -O "$filename" "$url" 2>&1 | ( ! grep -i "failed\|error\|denied" >&2 )
  elif [ -x "$(command -v curl)" ] && curl --help | grep -q -- "--retry-all-errors"; then
    curl --retry 3 --retry-all-errors -sSfLo "$filename" "$url"
  elif [ -x "$(command -v curl)" ]; then
    curl --retry 3 -sSfLo "$filename" "$url"
  else
    echo "Could not find wget or curl command" >&2
    return 1
  fi
}

# Detect the user environment and prepare accordingly
OS=$(uname)

case $OS in
Linux)
  mw_arch='glnxa64'
  bin_ext=''
  install_dir=${install_dir:-$DEFAULT_UNIX_INSTALL_LOCATION}
  ;;
Darwin)
  arch=$(uname -m)
  if echo "$arch" | grep -qE '^(x86_64|amd64)$'; then
    mw_arch='maci64'
  else
    mw_arch='maca64'
  fi
  bin_ext=''
  install_dir=${install_dir:-$DEFAULT_UNIX_INSTALL_LOCATION}
  ;;
CYGWIN*|MINGW32*|MSYS*|MINGW*)
  mw_arch='win64'
  bin_ext='.exe'
  install_dir=${install_dir:-$DEFAULT_WIN_INSTALL_LOCATION}
  ;;
*)
  echo "'$OS' operating system not supported"
  exit 1
  ;;
esac

# Create standard location for install if it does not exist
mkdir -p "$install_dir"

# Download the matlab-batch executable to a standard location
base_url=${DEFAULT_DOWNLOAD_BASE_URL}

{
  output=$(download "$base_url/$mw_arch/matlab-batch$bin_ext" "$install_dir/matlab-batch$bin_ext" 2>&1);
} || {
  msg=$(echo "$output" | head -1 | sed -e 's/^[[:space:]]*//')
  echo "Failed to download matlab-batch to the specified location ($msg)."
  exit 1;
}

# Allow executable permissions for matlab-batch
chmod a+x "$install_dir/matlab-batch$bin_ext"

# Place matlab-batch on the PATH if it is possible in the current environment
if [ "$OS" = "Linux" ] || [ "$OS" = "Darwin" ]; then
  # Convert install_dir to an absolute path if it is not already
  install_dir=$(cd "$install_dir" && pwd)

  # Check if install_dir is not /usr/local/bin and proceed with creating a symlink if true
  if [ "$install_dir" != "/usr/local/bin" ] && ln -fs "$install_dir/matlab-batch" /usr/local/bin/matlab-batch; then
    echo "symlink created in /usr/local/bin."
  elif [ "$install_dir" = "/usr/local/bin" ]; then
    echo "matlab-batch is installed in /usr/local/bin, no need to create a symbolic link." >&2
  else
    echo "Unable to create symbolic links for matlab-batch in /usr/local/bin. To run matlab-batch, '$install_dir/matlab-batch' must be on the system path." >&2
  fi
fi

echo "matlab-batch installed successfully."
#!/bin/bash

set -e

script_folder="`dirname $0`"

enroot_dir="./enroot"
pyxis_dir="./pyxis"

# Refs:
# - https://github.com/NVIDIA/enroot/blob/v3.3.1/doc/installation.md
# - https://github.com/NVIDIA/pyxis/wiki/Installation

# Install enroot
sudo apt-get update
sudo apt-get install -y git gcc make libcap2-bin libtool automake zstd
sudo apt-get install -y curl gawk jq squashfs-tools parallel

# Setup Nvidia container runtime package
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt-get update

sudo apt-get install -y fuse-overlayfs libnvidia-container-tools pigz squashfuse
git clone --recurse-submodules https://github.com/NVIDIA/enroot.git -b v3.3.1 $enroot_dir
sudo make --directory=$enroot_dir install
sudo make --directory=$enroot_dir setcap
sudo rm -rf $enroot_dir
sudo apt-get clean

# Enable PyTorch hook:
sudo cp /usr/local/share/enroot/hooks.d/50-slurm-pytorch.sh /usr/local/etc/enroot/hooks.d/

# Use our configuration:
sudo cp $script_folder/enroot.conf /usr/local/etc/enroot/enroot.conf

# Install pyxis
if [ -f "/opt/slurm/include/slurm/slurm.h" ] ; then
    git clone https://github.com/NVIDIA/pyxis.git $pyxis_dir
    sudo ln -s /opt/slurm/include/slurm /usr/include/slurm
    sudo make --directory=$pyxis_dir install
    sudo rm -rf $pyxis_dir
    sudo apt-get clean
fi


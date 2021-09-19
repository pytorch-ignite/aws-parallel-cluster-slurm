#!/bin/bash

enroot_dir="./enroot"
pyxis_dir="./pyxis"

# Refs:
# - https://github.com/NVIDIA/enroot/blob/v3.3.1/doc/installation.md
# - https://github.com/NVIDIA/pyxis/wiki/Installation

# Install enroot
git clone --recurse-submodules https://github.com/NVIDIA/enroot.git -b v3.3.1 $enroot_dir
sudo apt-get -y update
sudo apt install -y git gcc make libcap2-bin libtool automake zstd
sudo apt install -y curl gawk jq squashfs-tools parallel
sudo apt install -y fuse-overlayfs libnvidia-container-tools pigz squashfuse
sudo make --directory=$enroot_dir install
sudo make --directory=$enroot_dir setcap
sudo rm -rf $enroot_dir

# Install pyxis
if [ -f "/opt/slurm/include/slurm/slurm.h" ] ; then
    git clone https://github.com/NVIDIA/pyxis.git $pyxis_dir
    sudo ln -s /opt/slurm/include/slurm /usr/include/slurm
    sudo make --directory=$pyxis_dir install
    sudo rm -rf $pyxis_dir
fi


#!/bin/sh

enroot_dir="./enroot"
pyxis_dir="./pyxis"

#Install enroot
git clone --recurse-submodules https://github.com/NVIDIA/enroot.git $enroot_dir
sudo apt-get -y update && sudo apt-get install zstd
sudo apt install -y git gcc make libcap2-bin libtool automake
sudo apt install -y curl gawk jq squashfs-tools parallel
sudo apt install -y fuse-overlayfs libnvidia-container-tools pigz squashfuse
sudo make --directory=$enroot_dir install
sudo make --directory=$enroot_dir setcap
sudo rm -rf $enroot_dir


#Install pyxis 
git clone https://github.com/NVIDIA/pyxis.git $pyxis_dir
sudo ln -s /opt/slurm/include/slurm /usr/include/slurm
sudo make --directory=$pyxis_dir install
sudo rm -rf $pyxis_dir


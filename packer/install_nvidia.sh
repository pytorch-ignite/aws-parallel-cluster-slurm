#!/bin/bash
#sudo apt-get update -y
#distribution=$(. /etc/os-release;echo $ID$VERSION_ID) 
#curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - 
#curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
#sudo apt-get update -y
#sudo apt-get install -y nvidia-docker2
sudo apt-get update -y
echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list > /dev/null
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends nvidia-driver-460
sudo apt-get install -y nvidia-container-runtime
sudo apt-get clean

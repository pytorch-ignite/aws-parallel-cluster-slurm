#!/bin/sh
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo apt-get clean

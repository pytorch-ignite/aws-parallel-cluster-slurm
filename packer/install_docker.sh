#!/bin/sh

# Install Docker
sudo apt-get update -y
sudo apt-get --no-install-recommends install -y docker.io

# Adding using Docker without sudo 
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo apt-get clean

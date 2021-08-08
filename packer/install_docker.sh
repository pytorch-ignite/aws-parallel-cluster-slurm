#!/bin/sh

# Install Docker
sudo apt-get update -y
sudo apt-get install -y docker.io

# Adding using Docker without sudo 
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo apt-get clean

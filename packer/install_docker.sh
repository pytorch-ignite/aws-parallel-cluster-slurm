#!/bin/sh
sudo apt-get update -y
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y docker.io
sudo groupadd docker
sudo usermod -aG docker ubuntu
#sudo docker pull pytorchignite/base:latest
#sudo docker pull pytorchignite/vision:latest
#sudo docker pull pytorchignite/nlp:latest
#sudo docker pull pytorchignite/apex:latest
#sudo docker pull pytorchignite/apex-vision:latest
#sudo docker pull pytorchignite/apex-nlp:latest
#sudo docker pull pytorchignite/hvd-base:latest
#sudo docker pull pytorchignite/hvd-vision:latest
#sudo docker pull pytorchignite/hvd-nlp:latest
#sudo docker pull pytorchignite/hvd-apex:latest
#sudo docker pull pytorchignite/hvd-apex-vision:latest
#sudo docker pull pytorchignite/hvd-apex-nlp:latest
#sudo docker pull pytorchignite/msdp-apex:latest
#sudo docker pull pytorchignite/msdp-apex-vision:latest
#sudo docker pull pytorchignite/msdp-apex-nlp:latest
#sudo apt-get clean
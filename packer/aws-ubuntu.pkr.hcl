packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "ubuntu-pcluster-cuda-docker"
}

variable "ami_version" {
  type    = string
  default = "0.1.0"
}



source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${var.ami_version}"
  instance_type = "c5.large"
  region        = "us-east-2"
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 40
    delete_on_termination = true
  }
  source_ami_filter {
    filters = {
      image-id = "ami-00c145829972fe4f8"
    }
    most_recent = true
    owners      = ["247102896272"]
  }
  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    script = "install_docker.sh"
  }
  provisioner "shell" {
    script = "install_nvidia.sh"
  }
}


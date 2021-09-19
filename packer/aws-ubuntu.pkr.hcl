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
  default = "ubuntu-pcluster-cuda-enroot-pyxis"
}

variable "ami_version" {
  type    = string
  default = "0.3.0"
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
    # https://github.com/aws/aws-parallelcluster/blob/v2.11.2/amis.txt#L127
    # or https://us-east-2.console.aws.amazon.com/ec2/v2/home?region=us-east-2#Images:visibility=public-images;platform=ubuntu;ownerAlias=247102896272;creationDate=%3E2021-06-01T00:00+02:00;sort=name
    filters = {
      # aws-parallelcluster-2.11.2-ubuntu-2004-lts-hvm-x86_64-202108251000
      image-id = "ami-09b55f7d8195e33af"
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
    script = "install_nvidia.sh"
  }
  provisioner "shell" {
    script = "install_pyxis.bash"
  }
}


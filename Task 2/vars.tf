variable "region" {
  default = "us-west-2"
}

variable "prefix_name" {
  default = "hishab-devops"
}

variable "bucket_name" {
  default = "hishab-devops-bucket"
}

variable "db_password" {}

data "aws_ami" "ubuntu-ami" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200430"]
    }
    owners = ["554422223344"] # Canonical
}
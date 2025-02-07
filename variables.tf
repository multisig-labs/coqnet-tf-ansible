terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "zone_id" {
  description = "Zone ID"
  type        = string
  sensitive   = false
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "terraform_ssh_key" {
  description = "path of the public key to be used for ssh"
  type        = string
  sensitive   = false
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 3
}

variable "instance_type" {
  description = "The type of instance to launch"
  type        = string
  default     = "r5ad.large"
}

variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
  default     = "ami-036841078a4b68e14"
}

variable "disk_size" {
  description = "The size of the root volume in GB"
  type        = number
  default     = 1000
}

variable "disk_class" {
  description = "The class of the root volume"
  type        = string
  default     = "gp3"
}

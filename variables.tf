variable "aws_region" {
    type = string
    default = "us-east-1"  
}

variable "tags" {
    type = map(string)
    default = {}
}

variable "vpc_cidr" {
    type = string
    default = "172.16.0.0/16"
}

variable "vpc_name"{
    type = string
    default = "Main VPC"
}

variable "vpc_tags" {
    type = map(string)
    default = {}  
}

variable "public_subnets" {
   type = list(map(string))
    default = [
        {
          name = "test-public-1"
          az = "us-east-1c"
          cidr = "172.16.200.0/24"
        },
        {
          name = "test-public-2"
          az = "us-east-1d"
          cidr = "172.16.210.0/24"
        }
    ]
}

variable "private_subnets" {
   type = list(map(string))
    default = [
        {
          name = "test-priv-1"
          az = "us-east-1a"
          cidr = "172.16.100.0/24"
        },
        {
          name = "test-priv-2"
          az = "us-east-1b"
          cidr = "172.16.110.0/24"
        }
    ]
}

variable "subnet_tags" {
    type = map(string)
    default = {}
}

variable "enable_dns_hostnames" {
    type = bool
    default = false  
}

variable "enable_dns_support" {
    type = bool
    default = true  
}

variable "public_inbound" {
    type = list(map(string))
    default = []
}

variable "public_outbound" {
    type = list(map(string))
    default = []
}


variable "private_inbound" {
    type = list(map(string))
    default = []
}

variable "private_outbound" {
    type = list(map(string))
    default = []
}

variable "environment" {
  type = string
}

variable "dhcp_set" {
  type = any
  default = {}
}
variable "active_dhcp" {
  type = bool
  default = false
}
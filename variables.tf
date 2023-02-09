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
   type = map
    default = {
        "us-east-1a" = "172.16.100.0/24"
        "us-east-1b" = "172.16.110.0/24"
    }
}

variable "private_subnets" {
    type = map
    default = {
        "us-east-1a" = "172.16.0.0/24"
        "us-east-1b" = "172.16.1.0/24"
    }
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

variable "route_table_name" {
    type = map(string)
    default = {}  
}

variable "route_table_routes" {
    type = list(map(string))
    default = []
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
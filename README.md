# AWS VPC Terraform Module

Create an AWS VPC with related resources using Terraform

# Requirements

```hcl

terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40"
    }
  }
}
```


# Design Goals
1. Use `for_each` instead of `count` to limit change impact
2. Map AZ and CIDR to allow for easier mapping and readability
3. Allow for choosing active DHCP Options Set for the VPC


# TODO
- VPC Endpoints
- VPC Flow Logs



# Resources

The following resources are used in this module:

[aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)

[aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)

[aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table)

[aws_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route)

[aws_network_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_acls)

[aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/nat_gateway)

[aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eip)

[aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/internet_gateway)

[aws_vpc_dhcp_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_dhcp_options)


# Usage

This is an example of a full VPC setup

```hcl

module "main_vpc" {
  source = "./terraform-aws-vpc"

  vpc_name    = "GitHub-Test"
  vpc_cidr    = "10.10.0.0/16"
  environment = "Test"
  vpc_tags    = { "Environment" = "Test" }

  #Creates public subnets
  public_subnets = {
    "us-east-1c" = "10.10.100.0/24",
    "us-east-1d" = "10.10.200.0/24" }

  #Creates private subnets
  private_subnets = {
    "us-east-1a" = "10.10.0.0/24",
    "us-east-1b" = "10.10.10.0/24" }

  #Creates NACLs based on subnet type and egress/ingress
  public_inbound = [
    {
      protocol   = -1
      rule_no    = 10
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      to_port    = 0
      from_port  = 0
    }
  ]
  public_outbound = [
    {
      protocol   = "tcp"
      rule_no    = 10
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      to_port    = 443
      from_port  = 443
    },
    {
      protocol   = "tcp"
      rule_no    = 11
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      to_port    = 80
      from_port  = 80
    }
  ]
  private_inbound = [
    {
      protocol   = -1
      rule_no    = 10
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      to_port    = 0
      from_port  = 0
    }
  ]
  private_outbound = [
    {
      protocol   = -1
      rule_no    = 10
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      to_port    = 0
      from_port  = 0
    }
  ]

  #Creates DHCP Options Set while selecting active set
  dhcp_set = {
    "dhcp01" = {
      "domain_name"          = "test.com"
      "domain_name_servers"  = ["10.10.1.1", "10.10.1.2"]
      "ntp_servers"          = ["10.10.1.1"]
      "netbios_name_servers" = ["10.10.1.1"]
      "netbios_node_type"    = 2

    }
    "dhcp02" = {
      "domain_name"          = "test2.com"
      "domain_name_servers"  = ["10.10.1.1", "10.10.1.2"]
      "ntp_servers"          = ["10.10.1.1"]
      "netbios_name_servers" = ["10.10.1.1"]
      "netbios_node_type"    = 2
      "active_dhcp"          = true
    }
  }
}

```
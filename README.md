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

# Usage

This is an example of a full VPC setup

```hcl

module "main_vpc" {
  source = "./terraform-aws-vpc"

  vpc_name    = "GitHub-Test"
  vpc_cidr    = "10.10.0.0/16"
  environment = "Test"
  vpc_tags    = { "Environment" = "Test" }

  public_subnets = [
    {
      name = "dev-public-c"
      az   = "us-east-1c"
      cidr = "10.10.200.0/24"
    },
    {
      name = "dev-public-c1"
      az   = "us-east-1c"
      cidr = "10.10.210.0/24"
    },
    {
      name = "dev-public-d"
      az   = "us-east-1d"
      cidr = "10.10.220.0/24"
    }
  ]

  private_subnets = [
    {
      name = "dev-private-a"
      az   = "us-east-1a"
      cidr = "10.10.100.0/24"
    },
    {
      name = "dev-private-a2"
      az   = "us-east-1a"
      cidr = "10.10.110.0/24"
    },
    {
      name = "dev-private-b"
      az   = "us-east-1b"
      cidr = "10.10.120.0/24"
    }
  ]
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

*This module create the following resources:
*VPC
*Public and Private Subnets
*NAT Gateway
*Internet Gateway
*Network ACLs
*Routes
*DHCP Option Sets

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.40 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.53.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.natgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.private_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.public_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_subnet.main_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.main_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.dhcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.dhcp_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_dhcp"></a> [active\_dhcp](#input\_active\_dhcp) | n/a | `bool` | `false` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_dhcp_set"></a> [dhcp\_set](#input\_dhcp\_set) | n/a | `any` | `{}` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | n/a | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | n/a | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_private_inbound"></a> [private\_inbound](#input\_private\_inbound) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_private_outbound"></a> [private\_outbound](#input\_private\_outbound) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | `list(map(string))` | <pre>[<br>  {<br>    "az": "us-east-1a",<br>    "cidr": "172.16.100.0/24",<br>    "name": "test-priv-1"<br>  },<br>  {<br>    "az": "us-east-1b",<br>    "cidr": "172.16.110.0/24",<br>    "name": "test-priv-2"<br>  }<br>]</pre> | no |
| <a name="input_public_inbound"></a> [public\_inbound](#input\_public\_inbound) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_public_outbound"></a> [public\_outbound](#input\_public\_outbound) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | n/a | `list(map(string))` | <pre>[<br>  {<br>    "az": "us-east-1c",<br>    "cidr": "172.16.200.0/24",<br>    "name": "test-public-1"<br>  },<br>  {<br>    "az": "us-east-1d",<br>    "cidr": "172.16.210.0/24",<br>    "name": "test-public-2"<br>  }<br>]</pre> | no |
| <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name) | n/a | `map(string)` | `{}` | no |
| <a name="input_route_table_routes"></a> [route\_table\_routes](#input\_route\_table\_routes) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | `"172.16.0.0/16"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | n/a | `string` | `"Main VPC"` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gw"></a> [nat\_gw](#output\_nat\_gw) | n/a |
| <a name="output_nat_gw_ids"></a> [nat\_gw\_ids](#output\_nat\_gw\_ids) | n/a |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | n/a |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | n/a |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | n/a |
| <a name="output_public_subnets_ids"></a> [public\_subnets\_ids](#output\_public\_subnets\_ids) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |

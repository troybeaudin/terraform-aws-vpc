
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  
  tags = merge(
      {Name = var.vpc_name},
      var.tags,
      var.vpc_tags
  )
}

resource "aws_subnet" "main_private_subnets" {
  for_each = {for subnet in var.private_subnets : subnet.name => subnet}
  cidr_block = each.value.cidr
  vpc_id = aws_vpc.main.id
  availability_zone = each.value.az

  tags = merge(
    {Name = "main_private_${lower(var.environment)}_${split("-",each.value.az)[2]}"},
    var.tags,
    var.subnet_tags
  )
}

resource "aws_subnet" "main_public_subnets" {
  for_each = {for subnet in var.public_subnets : subnet.name => subnet}
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = true
  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    {Name = "main_public_${lower(var.environment)}_${split("-",each.value.az)[2]}"},
    var.tags,
    var.subnet_tags
  )
}
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
  for_each = var.private_subnets
  cidr_block = each.value
  vpc_id = aws_vpc.main.id
  availability_zone = each.key

  tags = merge(
    {Name = "main_private_${lower(var.environment)}_${split("-",each.key)[2]}"},
    var.tags,
    var.subnet_tags
  )
}

resource "aws_subnet" "main_public_subnets" {
  for_each = var.public_subnets
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = true
  cidr_block = each.value
  availability_zone = each.key

  tags = merge(
    {Name = "main_public_${lower(var.environment)}_${split("-",each.key)[2]}"},
    var.tags,
    var.subnet_tags
  )
}
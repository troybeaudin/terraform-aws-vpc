
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = {for k, v in var.public_subnets : v.name => aws_subnet.main_public_subnets[v.name]}
}

output "public_subnets_ids" {
  value = {for k, v in var.public_subnets : v.name => aws_subnet.main_public_subnets[v.name].id}
}

output "private_subnets" {
  value = {for k, v in var.private_subnets : v.name => aws_subnet.main_private_subnets[v.name]}
}

output "private_subnet_ids" {
  value = {for k, v in var.private_subnets : v.name => aws_subnet.main_private_subnets[v.name].id}
}

output "nat_gw_ids"{
  value = {for k, v in var.public_subnets : v.name => aws_nat_gateway.default[v.name].id}
}

output "nat_gw"{
  value = {for k, v in var.public_subnets : v.name => aws_nat_gateway.default[v.name]}
}
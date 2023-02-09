
output "vpc_id" {
  value = aws_vpc.main.id
}

output "pub_subnet_ids" {
  value = [for az, subnet in aws_subnet.main_public_subnets : subnet.id]
}

output "priv_subnet_ids" {
  value = [for az, subnet in aws_subnet.main_private_subnets : subnet.id]
}
resource "aws_nat_gateway" "default" {
    for_each = {for subnet in var.public_subnets : subnet.name => subnet}
    subnet_id = aws_subnet.main_public_subnets[each.key].id
    allocation_id = aws_eip.natgw[each.key].id

    tags = {
        Name = "${lower(var.vpc_name)}_natgw"
    }

    depends_on = [
      aws_internet_gateway.main, aws_eip.natgw
    ]
}

resource "aws_eip" "natgw" {
    for_each = {for subnet in var.public_subnets : subnet.name => subnet}
    vpc = true
}


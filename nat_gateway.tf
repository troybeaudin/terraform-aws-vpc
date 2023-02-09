resource "aws_nat_gateway" "default" {
    subnet_id = aws_subnet.main_public_subnets[keys(aws_subnet.main_public_subnets)[0]].id
    allocation_id = aws_eip.natgw.id

    tags = {
        Name = "${lower(var.vpc_name)}_natgw"
    }

    depends_on = [
      aws_internet_gateway.main, aws_eip.natgw
    ]
}

resource "aws_eip" "natgw" {
    vpc = true
}


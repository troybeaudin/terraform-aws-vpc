resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.default.id
    }

    dynamic "route" {
      for_each = var.route_table_routes == true ? [1] : []
      content {
        cidr_block                = route.value.cidr_block
        
        gateway_id                = lookup(route.value, "gateway_id", null)
        nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
        network_interface_id      = lookup(route.value, "network_interface_id", null)
        vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
        vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
      }
      
    }
    depends_on = [
      aws_nat_gateway.default
    ]

    tags = {
      Name = "Private-RT"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block                = "0.0.0.0/0"
        gateway_id                = aws_internet_gateway.main.id
    }

    tags = {
      Name = "Public-RT"
    }
    depends_on = [
      aws_internet_gateway.main
    ]
}

resource "aws_route_table_association" "private" {
    for_each = aws_subnet.main_private_subnets
    subnet_id = each.value.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
    for_each = aws_subnet.main_public_subnets
    subnet_id = each.value.id
    route_table_id = aws_route_table.public.id
}
resource "aws_network_acl" "public_egress" {
    vpc_id = aws_vpc.main.id
    subnet_ids = [for subnet in aws_subnet.main_public_subnets : subnet.id]

    dynamic "egress" {
      for_each = toset(var.public_outbound)
      content {
        protocol                  = lookup(egress.value, "protocol", null)
        rule_no                   = lookup(egress.value, "rule_no", null)
        action                    = lookup(egress.value, "action", null)
        cidr_block                = lookup(egress.value, "cidr_block", null)
        from_port                 = lookup(egress.value, "from_port", null)
        to_port                   = lookup(egress.value, "to_port", null)
      }
}

    dynamic "ingress" {
      for_each = toset(var.public_inbound)
      content {
        protocol                  = lookup(ingress.value, "protocol", null)
        rule_no                   = lookup(ingress.value, "rule_no", null)
        action                    = lookup(ingress.value, "action", null)
        cidr_block                = lookup(ingress.value, "cidr_block", null)
        from_port                 = lookup(ingress.value, "from_port", null)
        to_port                   = lookup(ingress.value, "to_port", null)
      }
    }
}

resource "aws_network_acl" "private_ingress" {
    vpc_id = aws_vpc.main.id
    subnet_ids = [for subnet in aws_subnet.main_private_subnets : subnet.id]

    dynamic "egress" {
      for_each = toset(var.private_outbound)
      content {
        protocol                  = lookup(egress.value, "protocol", null)
        rule_no                   = lookup(egress.value, "rule_no", null)
        action                    = lookup(egress.value, "action", null)
        cidr_block                = lookup(egress.value, "cidr_block", null)
        from_port                 = lookup(egress.value, "from_port", null)
        to_port                   = lookup(egress.value, "to_port", null)
      }
}

    dynamic "ingress" {
      for_each = toset(var.private_inbound)
      content {
        protocol                  = lookup(ingress.value, "protocol", null)
        rule_no                   = lookup(ingress.value, "rule_no", null)
        action                    = lookup(ingress.value, "action", null)
        cidr_block                = lookup(ingress.value, "cidr_block", null)
        from_port                 = lookup(ingress.value, "from_port", null)
        to_port                   = lookup(ingress.value, "to_port", null)
      }
    }
}
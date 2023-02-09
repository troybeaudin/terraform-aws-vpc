resource "aws_vpc_dhcp_options" "dhcp" {
  for_each = var.dhcp_set

  domain_name = each.value["domain_name"]
  domain_name_servers = each.value["domain_name_servers"]
  ntp_servers = each.value["ntp_servers"]
  netbios_name_servers = each.value["netbios_name_servers"]
  netbios_node_type = each.value["netbios_node_type"]
  
  tags = {Name = "${each.value["domain_name"]}_dhcp_set"}

}


resource "aws_vpc_dhcp_options_association" "dhcp_set" {
  vpc_id = aws_vpc.main.id
  for_each = {for k, v in var.dhcp_set : k => v if can(v.active_dhcp)}
  dhcp_options_id = aws_vpc_dhcp_options.dhcp[each.key].id
}
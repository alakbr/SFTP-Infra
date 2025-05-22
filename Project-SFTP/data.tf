data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = [var.private_subnet_tags["Name"]]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = [var.public_subnet_tags["Name"]]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_tags["Name"]]
  }
}

data "aws_vpc_endpoint" "vpc" {
  count  = length(aws_transfer_server.transfer.endpoint_details)
  id     = aws_transfer_server.transfer.endpoint_details[count.index].vpc_endpoint_id
  vpc_id = aws_transfer_server.transfer.endpoint_details[count.index].vpc_id
}

output "eni_ids" {
  value = [
    for i in range(0, length(aws_transfer_server.transfer.endpoint_details)) :
    data.aws_vpc_endpoint.vpc[i].network_interface_ids
  ]

}

locals {
  eni_ids = flatten([
    for i in range(0, length(aws_transfer_server.transfer.endpoint_details)) :
    data.aws_vpc_endpoint.vpc[i].network_interface_ids
  ])
}

data "aws_network_interface" "vpc_endpoint_enis" {
  count      = length(data.aws_subnets.private_subnets.ids)
  id         = local.eni_ids[count.index]
  depends_on = [aws_transfer_server.transfer]
}

output "eni_private_ipv4_aadrs" {
  value = data.aws_network_interface.vpc_endpoint_enis[*].private_ip

}

# Create the Load Balancer Target Group Attachment
resource "aws_lb_target_group_attachment" "sftp_target_group_attachment" {
  count            = length(data.aws_network_interface.vpc_endpoint_enis)
  target_group_arn = aws_lb_target_group.sftp_target_group.arn
  target_id        = data.aws_network_interface.vpc_endpoint_enis[count.index].private_ip
  port             = 22
}
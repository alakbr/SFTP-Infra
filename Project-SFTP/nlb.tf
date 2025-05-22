resource "aws_lb" "sftp_nlb" {
  name               = "sftp-nlb"
  internal           = false # Set to true for internal use
  load_balancer_type = "network"
  security_groups    = [aws_security_group.transfer_nlb.id]
  subnets            = data.aws_subnets.all_subnets.ids # List of subnet IDs across multiple AZs

  dynamic "subnet_mapping" {
    for_each = data.aws_subnets.public_subnets.ids
    content {
      subnet_id     = subnet_mapping.value
      allocation_id = aws_eip.transfer[subnet_mapping.key].id
    }

  }
}

resource "aws_security_group" "transfer_nlb" {
  name        = "transfer_nlb"
  description = "allow inbound traffic to the sftp server endpint"
  vpc_id      = data.aws_vpc.vpc.id

}

resource "aws_vpc_security_group_ingress_rule" "inbound_transfer_nlb" {
  security_group_id = aws_security_group.transfer_nlb.id
  cidr_ipv4         = "149.34.186.225/32"
  ip_protocol       = "TCP"
  from_port         = 22
  to_port           = 22

}

# egress rule to allow ssh traffic to the sftp SG
resource "aws_security_group_rule" "outbound_transfer_healthcheck" {
  type                     = "egress"
  security_group_id        = aws_security_group.transfer_nlb.id
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.transfer.id
}

resource "aws_eip" "transfer" {
  count  = length(data.aws_subnets.public_subnets)
  domain = "vpc"
}

resource "aws_lb_target_group" "sftp_target_group" {
  name        = "sftp-target-group"
  port        = 22
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.vpc.id

  health_check {
    protocol = "TCP"
    port     = "22"
  }
}

resource "aws_lb_listener" "transfer" {
  load_balancer_arn = aws_lb.sftp_nlb.arn
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sftp_target_group.arn
  }

}
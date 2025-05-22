resource "aws_transfer_server" "transfer" {
  endpoint_type               = "VPC"
  identity_provider_type      = "SERVICE_MANAGED"
  protocols                   = ["SFTP"]
  structured_log_destinations = ["${aws_cloudwatch_log_group.transfer.arn}"]

  endpoint_details {
    subnet_ids         = data.aws_subnets.private_subnets.ids
    vpc_id             = data.aws_vpc.vpc.id
    security_group_ids = [aws_security_group.transfer.id]
  }
  tags = {
    Name = "Transfer"
  }
}

resource "aws_security_group" "transfer" {
  name        = "transfer"
  description = "allow inbound traffic to the sftp server endpint"
  vpc_id      = data.aws_vpc.vpc.id

}

# ingress rule to allow traffic from nlb SG
resource "aws_security_group_rule" "inbound_transfer_nlb" {
  type                     = "ingress"
  security_group_id        = aws_security_group.transfer.id
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.transfer_nlb.id # Reference to the first SG
}

resource "aws_cloudwatch_log_group" "transfer" {
  name              = "/aws/transfer/sftp_server"
  retention_in_days = 7

}




#Define SSH Keys for each user
resource "aws_transfer_ssh_key" "user_keys" {
  for_each   = toset(var.sftp_users)
  depends_on = [aws_transfer_user.sftp_user]

  server_id = aws_transfer_server.transfer.id
  user_name = each.key
  body      = chomp(file("${path.module}/files/${each.key}-user.pub"))
}

resource "aws_transfer_user" "sftp_user" {
  for_each = toset(var.sftp_users)

  server_id = aws_transfer_server.transfer.id
  user_name = each.key
  role      = aws_iam_role.sftp_role.arn

  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/${each.key}"
    target = "/sftpbucketch786110/${each.key}"
  }
}


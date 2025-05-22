resource "aws_s3_bucket" "sftp" {
  bucket = "sftpbucketch786110"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sftp" {
  bucket = aws_s3_bucket.sftp.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.acsp-s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "sftp_block" {
  bucket = aws_s3_bucket.sftp.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

############ create folders for each client for csv files #############

resource "aws_s3_object" "user_folders" {
  for_each = toset(var.sftp_users)

  bucket = aws_s3_bucket.sftp.bucket
  key    = "${each.key}/" # This simulates a folder for each user
  acl    = "private"

  # Content is optional; using an empty string to create the "folder"
  content = ""
}





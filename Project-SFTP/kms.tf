#KMS key to encryp data in the s3 buckets

resource "aws_kms_key" "acsp-s3" {
  description         = "CMK for S3 bucket data encryption"
  enable_key_rotation = true

}

resource "aws_kms_alias" "acsp-s3" {
  name          = "alias/acsp-s3-cmk"
  target_key_id = aws_kms_key.acsp-s3.key_id
}
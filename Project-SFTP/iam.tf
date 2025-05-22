resource "aws_iam_role" "sftp_role" {
  name               = "transfer-user-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}



resource "aws_iam_role_policy" "sftp_user_policy" {

  name = "s3_access_policy"
  role = aws_iam_role.sftp_role.name

  policy = data.aws_iam_policy_document.sftp_user_policy.json
}

data "aws_iam_policy_document" "sftp_user_policy" {

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.sftp.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.sftp.bucket}/*"
    ]
  }
}
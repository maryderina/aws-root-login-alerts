resource "aws_kms_key" "rootalerts_kms" {
  description         = "root login alerts"
  enable_key_rotation = true
  deletion_window_in_days = var.kms_deletion_window
}

resource "aws_kms_key_policy" "key" {
  key_id = aws_kms_key.rootalerts_kms.arn
  policy = <<EOF
  {
    "Version" : "2012-10-17",
    "Id" : "key-1",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Enable CloudTrail to encrypt logs",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudtrail.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*"
      },
      {
      "Sid": "Allow S3 bucket encryption",
      "Effect": "Allow",
      "Principal": {"Service": "s3.amazonaws.com"},
      "Action": [
         "kms:Encrypt*",
         "kms:Decrypt*",
         "kms:ReEncrypt*",
         "kms:GenerateDataKey*",
         "kms:Describe*"
      ],
      "Resource": "*"
    },
      {
      "Sid": "Allow S3 bucket encryption",
      "Effect": "Allow",
      "Principal": {"Service": "logs.${var.aws_region}.amazonaws.com"},
      "Action": [
         "kms:Encrypt*",
         "kms:Decrypt*",
         "kms:ReEncrypt*",
         "kms:GenerateDataKey*",
         "kms:Describe*"
      ],
      "Resource": "*"
    }
  ]
  }
  EOF
}
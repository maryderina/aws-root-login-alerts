#creating S3 bucket for storing cloutrail logs
resource "aws_s3_bucket" "alert_s3_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms-s3" {
  bucket = aws_s3_bucket.alert_s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.rootalerts_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket_versioning" "versioning_enable" {
  bucket = aws_s3_bucket.alert_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.alert_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


#attaching s3 bucket policy
resource "aws_s3_bucket_policy" "alert_s3_bucket_policy" {
  bucket = aws_s3_bucket.alert_s3_bucket.id
  policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudTrail",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.alert_s3_bucket.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.alert_s3_bucket.arn}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOF
}


#Lifecycle rule
resource "aws_s3_bucket_lifecycle_configuration" "example_bucket_lifecycle" {
  bucket = aws_s3_bucket.alert_s3_bucket.id

  rule {
    id     = "s3-lifecycle-rule"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

variable "AWS_ACCESS_KEY" {
  description = "AWS Access Key ID"
  default     = ""
}

variable "AWS_SECRET_KEY" {
  description = "AWS Secret Access Key"
  default     = ""
}


variable "aws_region" { default = "ca-central-1" }


variable "bucket_name" {
  default = "cloudtrail-s3-mdkd"
}

variable "tags" {
  type = map(any)
  default = {
    Environment = "Terraform"
    Team        = "IS"
    Name        = "Internal Lab"
  }
}

variable "cloudtrail_name" {
  default = "CloudTrailEvents"

}

variable "cloudtrail_role" {
  default = "cloudtrail_role"
}

variable "stream_policy" {
  default = "stream_access_policy"

}

variable "login_notification" {
  default = "SecurityAlerts"

}


variable "eventname" {
  default = "LoginRootAccount"

}


variable "namespace" {
  default = "CloudTrailMetrics"

}
variable "notificationemail" {
  type    = list(string)
  default = ["email1", "email2"]
}

variable "logbucket" {
  default = "logbucket-s3-mdkd"
}

variable "kms_deletion_window" {
  default = 7
  type    = number
}

variable "account_id" {
  description = "The account ID of the AWS account. Defaults to sandbox."
  default     = "accountID"
}



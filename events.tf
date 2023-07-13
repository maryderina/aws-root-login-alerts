

#creating CloudTrail and enabling cloudwatch Logs
resource "aws_cloudtrail" "login_audit_trail" {
  name                          = "user-login-notification-trail"
  s3_bucket_name                = aws_s3_bucket.alert_s3_bucket.bucket
  is_multi_region_trail         = true
  is_organization_trail         = false
  include_global_service_events = true
  enable_logging                = true
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.CloudTrailEvents.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
  kms_key_id                    = aws_kms_key.rootalerts_kms.arn
  tags                          = var.tags

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}



#creating CloudWatch Log Group
resource "aws_cloudwatch_log_group" "CloudTrailEvents" {
  name       = var.cloudtrail_name
  kms_key_id = aws_kms_key.rootalerts_kms.arn
}

#Configuring the necessary permissions to enable CloudTrail to send logs to CloudWatch
resource "aws_iam_role" "cloudtrail_role" {
  name               = var.cloudtrail_role
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy" "stream_logging_policy" {
  name = var.stream_policy
  role = aws_iam_role.cloudtrail_role.id

  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "logs:CreateLogStream",
                  "logs:PutLogEvents"
              ],
              "Resource": [
                "${aws_cloudwatch_log_group.CloudTrailEvents.arn}:*"
              ]
          }
      ]
}
EOF
}

#Enabling SNS for alert notifications. Manual subscription is required for receiving the alerts. Check Email
resource "aws_sns_topic" "root_access_alert" {
  name = var.login_notification
}

resource "aws_sns_topic_subscription" "user_login_notification_subscription" {
  for_each  = toset(var.notificationemail)
  topic_arn = aws_sns_topic.root_access_alert.arn
  protocol  = "email"
  endpoint  = each.key
}

#Establishing CloudWatch metrics and configuring corresponding alarms.
resource "aws_cloudwatch_log_metric_filter" "rootEvent" {
  name           = "Root_Account_Login"
  pattern        = <<EOF
 { ( $.userIdentity.type = "Root" ) }
EOF
  log_group_name = aws_cloudwatch_log_group.CloudTrailEvents.name

  metric_transformation {
    name      = var.eventname
    namespace = var.namespace
    value     = "1"
  }
}

data "aws_caller_identity" "current" {}

#creating alarm for triggering Root Logins
resource "aws_cloudwatch_metric_alarm" "RootLoginAlarm" {
  alarm_name          = "Security Alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = var.eventname
  namespace           = var.namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"

  alarm_description = "in the AWS account with id = ${data.aws_caller_identity.current.account_id} the root user logged in"
  alarm_actions     = ["${aws_sns_topic.root_access_alert.arn}"]
}

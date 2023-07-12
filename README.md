# AWS Root User Login Alert

This Terraform script sets up an alert mechanism to send email notifications whenever a root user logs into an AWS account. The script creates the necessary AWS resources, such as an SNS topic, IAM roles, CloudTrail, and CloudWatch Logs, kms and configures them to enable logging and notification functionality.

## Prerequisites

Before running this Terraform script, ensure you have the following:

- AWS CLI configured with appropriate credentials
- Terraform installed on your machine
- An email address to receive the root user login alerts

## Usage

Follow the steps below to use this Terraform script:

1. Clone the repository:
   ```shell
   git clone https://github.com/maryderina/aws-root-login-alerts.git


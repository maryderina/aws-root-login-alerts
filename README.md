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

Navigate to the project directory:
  ```shell
  cd aws-root-login-alerts

2. Initialize the terraform working directory:
  ```shell
  terraform init
3. Modify the variables in the variables.tf file:
Update the notification_email variable with your email address.
Optionally, modify other variables to customize the setup according to your requirements. Refer to the comments in the variables.tf file for more information.

4. Review the changes that will be applied:
  ```shell
  terraform plan -out plan.out

5. Apply the Terraform changes to create the AWS resources:
  ```shell
  terraform apply "plan.out"

6. Verify the setup and test by logging into the AWS account as the root user. You should receive an email notification at the specified email address.

7. If you want to tear down the resources and remove the alert mechanism:
  ```shell
  terraform destroy

##Customization
You can customize the behavior of this script by modifying the variables in the variables.tf file. Here are some variables you may consider changing:
access_key(#Don't put these in your code! Use environment variables or a vault for best practice)
secret_key(#Don't put these in your code! Use environment variables or a vault for best practice)
aws_region
tags
notificationemail
accountid

##Contributing
Contributions are welcome! If you find any issues or want to enhance the functionality, feel free to submit a pull request.



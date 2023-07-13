terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
  #Don't put these in your code! Use environment variables or a vault.
  access_key = var.AWS_ACCESS_KEY #Capitalized to distinguish it as an environment variable.
  secret_key = var.AWS_SECRET_KEY
  #  token = var.AWS_TOKEN
}


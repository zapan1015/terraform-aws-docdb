terraform {
  backend "s3" {
    bucket         = "aws-chat-dev-sodanest-state"
    key            = "aws/chat-dev/apne2/docdb/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "aws-chat-dev-sodanest-lock"
    role_arn       = "arn:aws:iam::327226472731:role/terraform-runner-chat-dev"
    session_name   = "soda-apne2-docdb"
  }
}

## VPC Remote
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket         = "aws-chat-dev-sodanest-state"
    key            = "aws/chat-dev/apne2/vpc/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "aws-chat-dev-sodanest-lock"
    role_arn       = "arn:aws:iam::327226472731:role/terraform-runner-chat-dev"
    session_name   = "soda-apne2-docdb"
  }
}

## Information about a DocumentDB engine version.
data "aws_docdb_engine_version" "docdb" {
  version = var.engine_version
}

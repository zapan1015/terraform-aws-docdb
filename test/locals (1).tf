locals {
  sendbird_region = "test-seoul"
  aws_region      = "ap-northeast-2"

  product = "friend"
  app     = "docdb"
  detail  = ""
  env     = "dev"

  engine                = data.aws_docdb_engine_version.docdb.engine
  engine_version        = data.aws_docdb_engine_version.docdb.version
  parametergroup_family = data.aws_docdb_engine_version.docdb.parameter_group_family

  ## VPC
  # vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  # subnets = toset([data.terraform_remote_state.vpc.outputs.private_subnets])
  # test-seoul-vpc
  vpc_id = "vpc-08e2a830bff8c51a4"
  subnets = var.subnets
  docdb_security_group_ids = []

  instances = {
    "1" = { instance_name = "1", instance_class = "db.t3.medium", promotion_tier = 0, availability_zone = var.availability_zones[0] }
    "2" = { instance_name = "2", instance_class = "db.t3.medium", promotion_tier = 1, availability_zone = var.availability_zones[1] }
  }

  # sns_topic = "arn:aws:sns:ap-northeast-2:327226472731:notify-chatbot-mesg-dev-team-product-alerts-data-infra"
  # event_subscriptions = {
  #   1 = {
  #     source_type      = "db-cluster"
  #     event_categories = join(", ", ["failover", "deletion", "notification", "maintenance", "failure"])
  #   }
  #   2 = {
  #     source_type      = "db-instance"
  #     event_categories = join(", ", ["maintenance", "failover", "restoration", "recovery", "failure", "low storage", "deletion", "notification"])
  #   }
  # }
}

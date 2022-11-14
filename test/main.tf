module "docdb" {
  source = "../../../"

  subnets                         = local.subnets
  sendbird_region                 = local.sendbird_region
  engine                          = local.engine
  engine_version                  = local.engine_version
  availability_zones              = var.availability_zones
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  aws_docdb_cluster_options       = var.aws_docdb_cluster_options
  aws_docdb_instance_options      = var.aws_docdb_instance_options
  instances                       = local.instances
  vpc_id                          = local.vpc_id
  product                         = local.product
  docdb_subnet_group_name         = var.docdb_subnet_group_name
  vpc_security_group_ids          = local.docdb_security_group_ids
  env                             = local.env
  app                             = local.app
  detail                          = local.detail
  snapshot_identifier             = var.snapshot_identifier
  parametergroup_family           = local.parametergroup_family
}

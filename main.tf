resource "random_string" "docdb" {
  length  = 8
  upper   = false
  lower   = true
  number  = true
  special = false
}

## subnet group
resource "aws_docdb_subnet_group" "docdb" {
  count      = var.docdb_subnet_group_name == "" ? 1 : 0
  name       = format("%s-docdbsubnetgroup", local.name)
  subnet_ids = var.subnets
  tags = merge(
    { Name = local.name },
    local.tags
  )
}

resource "aws_docdb_cluster_parameter_group" "docdb" {
  name   = format("%s-docdbclusterparametergroup", local.name)
  family = var.parametergroup_family
  tags = merge(
    { Name = local.name },
    local.tags
  )

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "docdb" {
  name        = format("%s-security-group", local.name)
  description = "DocumentDB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = local.port
    to_port   = local.port
    protocol  = "tcp"
  }
  tags = merge(
    { Name = local.name },
    local.tags
  )
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier              = format("%s-docdbcluster", local.name)
  engine                          = var.engine
  engine_version                  = var.engine_version
  port                            = local.port
  master_username                 = var.master_username
  master_password                 = random_string.docdb.result
  skip_final_snapshot             = local.skip_final_snapshot
  final_snapshot_identifier       = format("%s-final-snapshot", local.name)
  snapshot_identifier             = var.snapshot_identifier
  deletion_protection             = local.deletion_protection
  db_subnet_group_name            = local.docdb_subnet_group_name
  storage_encrypted               = local.storage_encrypted
  kms_key_id                      = local.kms_key_id
  apply_immediately               = var.apply_immediately
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb.name
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  availability_zones              = var.availability_zones
  vpc_security_group_ids          = compact(concat([aws_security_group.docdb.id], var.vpc_security_group_ids))
  backup_retention_period         = local.backup_retention_period
  preferred_maintenance_window    = local.cluster_preferred_maintenance_window
  lifecycle {
    ignore_changes = [availability_zones, master_password]
  }
  tags = merge(
    { Name = local.name },
    local.tags
  )
}

resource "aws_docdb_cluster_instance" "docdb" {
  for_each = {
    for key, value in var.instances : key => {
      instance_name     = value.instance_name
      promotion_tier    = value.promotion_tier
      availability_zone = value.availability_zone
      instance_class    = value.instance_class
    }
  }
  cluster_identifier           = aws_docdb_cluster.docdb.id
  instance_class               = each.value["instance_class"]
  identifier                   = format("sb-%s-%s", local.name, each.value["instance_name"])
  engine                       = var.engine
  apply_immediately            = var.apply_immediately
  auto_minor_version_upgrade   = local.auto_minor_version_upgrade
  availability_zone            = each.value["availability_zone"]
  promotion_tier               = each.value["promotion_tier"]
  preferred_maintenance_window = local.instance_preferred_maintenance_window
  lifecycle {
    ignore_changes = [availability_zone]
  }
  tags = merge(
    { Name = local.name },
    local.tags
  )
}

## DB Event Subscriptions
# resource "aws_db_event_subscription" "docdb" {
#   for_each = {
#     for key, value in var.event_subscriptions : key => {
#       source_type       = value.source_type
#       event_categories  = value.event_categories
#     }
#   }

#   name             = each.value["source_type"] == "db-cluster" ? format("%s-ClusterEventSubscription", local.name) : format("%s-InstanceEventSubscription", local.name)
#   sns_topic        = var.sns_topic
#   source_type      = each.value["source_type"]
#   source_ids       = each.value["source_type"] == "db-cluster" ? toset([aws_docdb_cluster.docdb.id]) : toset([aws_docdb_cluster_instance.docdb[each.key].id]) 
#   event_categories = toset([each.value["event_categories"]])

#   tags = merge(
#     { Name = local.name },
#     local.tags
#   )
# }

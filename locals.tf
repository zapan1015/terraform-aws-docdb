locals {
  port                                  = lookup(var.aws_docdb_cluster_options, "port", local.default_aws_docdb_cluster_options["port"])
  deletion_protection                   = lookup(var.aws_docdb_cluster_options, "deletion_protection", local.default_aws_docdb_cluster_options["deletion_protection"])
  backup_retention_period               = lookup(var.aws_docdb_cluster_options, "backup_retention_period", local.default_aws_docdb_cluster_options["backup_retention_period"])
  cluster_preferred_maintenance_window  = lookup(var.aws_docdb_cluster_options, "preferred_maintenance_window", local.default_aws_docdb_cluster_options["preferred_maintenance_window"])
  storage_encrypted                     = lookup(var.aws_docdb_cluster_options, "storage_encrypted", local.default_aws_docdb_cluster_options["storage_encrypted"])
  kms_key_id                            = lookup(var.aws_docdb_cluster_options, "kms_key_id", local.default_aws_docdb_cluster_options["kms_key_id"])
  skip_final_snapshot                   = lookup(var.aws_docdb_cluster_options, "skip_final_snapshot", local.default_aws_docdb_cluster_options["skip_final_snapshot"])
  auto_minor_version_upgrade            = lookup(var.aws_docdb_instance_options, "auto_minor_version_upgrade", local.default_aws_docdb_instance_options["auto_minor_version_upgrade"])
  instance_preferred_maintenance_window = lookup(var.aws_docdb_instance_options, "preferred_maintenance_window", local.default_aws_docdb_instance_options["preferred_maintenance_window"])

  docdb_subnet_group_name = var.docdb_subnet_group_name == "" ? join("", aws_docdb_subnet_group.docdb.*.name) : var.docdb_subnet_group_name

  sbregion    = replace(var.sendbird_region, "-", "")
  name_suffix = var.detail == "" ? random_string.docdb.result : var.detail
  name        = join("-", compact(tolist([format("%s%s", var.product, local.sbregion), var.app, local.name_suffix])))
  default_tags = {
    app             = var.app,
    product         = var.product,
    sendbird_region = var.sendbird_region,
    sbregion        = local.sbregion,
    env             = var.env,
    detail          = var.detail,
    managed_by      = "terraform"
    owner           = "infrastructure@sendbird.com",
  }
  tags = merge(
    local.default_tags,
    var.tags
  )
}

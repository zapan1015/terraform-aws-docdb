variable "subnets" {
  description = "The list of subnet ids to deploy"
  type        = list(string)
}

variable "aws_docdb_cluster_options" {
  description = "A map of DocumentDB Cluster"
  type        = map(any)
  default     = {}
}

variable "aws_docdb_instance_options" {
  description = "A map of DocumentDB Cluster Instance"
  type        = map(any)
  default     = {}
}

variable "cluster_parameters" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "List of DocumentDB cluster parameters to apply"
}

variable "instances" {
  description = "A map of instance related variables"
  type = map(object({
    instance_name     = string
    instance_class    = string
    promotion_tier    = string
    availability_zone = string
  }))
}

variable "parametergroup_family" {
  type        = string
  default     = "docdb4.0"
  description = "The DocumentDB Cluster Parameter Group family name."
}

## Cluster variables
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "engine" {
  type        = string
  default     = "docdb"
  description = "The name of the database engine to be used for this DocumentDB cluster."
}

variable "engine_version" {
  type        = string
  default     = ""
  description = "The database engine version."
}

variable "availability_zones" {
  type        = list(string)
  default     = []
  description = "A list of EC2 Availability Zones for the DocumentDB cluster storage where DocumentDB cluster instances can be created"
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Determines whether or not any DocumentDB modifications are applied immediately, or during the maintenance window"
}

variable "docdb_cluster_parameter_group_name" {
  type        = string
  default     = ""
  description = "The name of a DocumentDB Cluster parameter group to use"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(any)
  default     = {}
}

variable "app" {
  description = "Application purpose"
  type        = string
}

variable "sendbird_region" {
  type        = string
  description = "Customer name"
}

variable "product" {
  type        = string
  description = "SendBird Product"
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "detail" {
  description = "additional information"
  type        = string
  default     = ""
}

variable "iam_roles" {
  description = "A list of ARNs for the IAM roles to associate to the DocumentDB Cluster"
  type        = string
  default     = ""
}

variable "master_username" {
  default     = "sb_docdb"
  description = "Master DocumentDB username"
  type        = string
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = []
}

variable "docdb_subnet_group_name" {
  description = "A name of DocumentDB subnet_group"
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster in addition to the SG we create in this module"
  type        = list(string)
  default     = []
}

variable "snapshot_identifier" {
  description = "specifies whether or not to create this cluster from a snapshot"
  type        = string
}

## DB Event Subscriptions
variable "sns_topic" {
  description = "arn of sns_topic"
  type        = string
  default     = ""
}

variable "event_subscriptions" {
  description = "A map of aws_db_event_subscription variables"
  type = map(object({
    source_type      = string
    event_categories = string
  }))
  default = {}
}

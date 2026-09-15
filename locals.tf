locals {
  name_prefix  = "${var.project_name}-${var.environment}"
  cluster_name = local.name_prefix

  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

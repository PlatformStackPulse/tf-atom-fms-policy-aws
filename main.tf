resource "aws_fms_policy" "this" {
  count = local.enabled ? 1 : 0

  name                               = module.this.id
  exclude_resource_tags              = var.exclude_resource_tags
  remediation_enabled                = var.remediation_enabled
  resource_type                      = var.resource_type
  resource_type_list                 = var.resource_type_list
  delete_all_policy_resources        = var.delete_all_policy_resources
  delete_unused_fm_managed_resources = var.delete_unused_fm_managed_resources

  dynamic "include_map" {
    for_each = length(var.include_account_ids) > 0 ? [1] : []
    content {
      account = var.include_account_ids
    }
  }

  dynamic "exclude_map" {
    for_each = length(var.exclude_account_ids) > 0 ? [1] : []
    content {
      account = var.exclude_account_ids
    }
  }

  security_service_policy_data {
    type                 = var.policy_type
    managed_service_data = var.managed_service_data
  }

  tags = module.this.tags
}

variable "policy_type" {
  type        = string
  description = "Type of FMS policy. Valid values: WAF, WAFV2, SHIELD_ADVANCED, SECURITY_GROUPS_COMMON, SECURITY_GROUPS_CONTENT_AUDIT, SECURITY_GROUPS_USAGE_AUDIT, NETWORK_FIREWALL, DNS_FIREWALL, THIRD_PARTY_FIREWALL, IMPORT_NETWORK_FIREWALL."
  validation {
    condition = contains([
      "WAF", "WAFV2", "SHIELD_ADVANCED",
      "SECURITY_GROUPS_COMMON", "SECURITY_GROUPS_CONTENT_AUDIT", "SECURITY_GROUPS_USAGE_AUDIT",
      "NETWORK_FIREWALL", "DNS_FIREWALL", "THIRD_PARTY_FIREWALL", "IMPORT_NETWORK_FIREWALL"
    ], var.policy_type)
    error_message = "Invalid policy type."
  }
}

variable "managed_service_data" {
  type        = string
  description = "JSON-encoded managed service data for the policy. Structure depends on policy_type."
  default     = null
}

variable "resource_type" {
  type        = string
  description = "Resource type to protect. Use resource_type OR resource_type_list, not both."
  default     = null
}

variable "resource_type_list" {
  type        = list(string)
  description = "List of resource types to protect."
  default     = null
}

variable "exclude_resource_tags" {
  type        = bool
  description = "Whether to exclude resources with specified tags."
  default     = false
}

variable "remediation_enabled" {
  type        = bool
  description = "Whether FMS should automatically remediate non-compliant resources."
  default     = false
}

variable "include_account_ids" {
  type        = list(string)
  description = "List of AWS account IDs to include in the policy scope."
  default     = []
}

variable "exclude_account_ids" {
  type        = list(string)
  description = "List of AWS account IDs to exclude from the policy scope."
  default     = []
}

variable "delete_all_policy_resources" {
  type        = bool
  description = "Whether to delete all resources managed by this policy when deleting the policy."
  default     = false
}

variable "delete_unused_fm_managed_resources" {
  type        = bool
  description = "Whether to delete unused FM-managed resources."
  default     = false
}

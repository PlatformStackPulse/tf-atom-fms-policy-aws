output "policy_id" {
  description = "The ID of the FMS Policy."
  value       = try(aws_fms_policy.this[0].id, "")
}

output "policy_arn" {
  description = "The ARN of the FMS Policy."
  value       = try(aws_fms_policy.this[0].arn, "")
}

output "policy_update_token" {
  description = "The update token of the FMS Policy."
  value       = try(aws_fms_policy.this[0].policy_update_token, "")
}

output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}

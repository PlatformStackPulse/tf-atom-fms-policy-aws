# Unit Tests for tf-atom-fms-policy-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run specific:     terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# Assertions target plan-KNOWN values only (tf-label id, resource count,
# input pass-throughs, enabled flag). Computed attributes such as arn/id/
# policy_update_token are unknown under a mock provider and are NOT asserted.

mock_provider "aws" {}

variables {
  # tf-label context
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Module-required input
  policy_type = "WAFV2"

  # Optional but realistic sample data
  remediation_enabled = true
  managed_service_data = jsonencode({
    type                              = "WAFV2"
    preProcessRuleGroups              = []
    postProcessRuleGroups             = []
    defaultAction                     = { type = "ALLOW" }
    overrideCustomerWebACLAssociation = false
  })
}

# ---------------------------------------------------------------------------
# Test: module creates exactly one FMS policy when enabled (the default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = length(aws_fms_policy.this) == 1
    error_message = "Expected exactly one aws_fms_policy when enabled = true."
  }

  assert {
    condition     = aws_fms_policy.this[0].name == "eg-test-thing"
    error_message = "FMS policy name should equal the tf-label id 'eg-test-thing'."
  }

  assert {
    condition     = aws_fms_policy.this[0].security_service_policy_data[0].type == "WAFV2"
    error_message = "security_service_policy_data.type should pass through policy_type (WAFV2)."
  }

  assert {
    condition     = aws_fms_policy.this[0].remediation_enabled == true
    error_message = "remediation_enabled input should pass through to the resource."
  }

  assert {
    condition     = output.enabled == true
    error_message = "enabled output should be true when the module is enabled."
  }
}

# ---------------------------------------------------------------------------
# Test: module creates no resources when enabled = false
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_fms_policy.this) == 0
    error_message = "No aws_fms_policy should be created when enabled = false."
  }

  assert {
    condition     = output.policy_id == ""
    error_message = "policy_id output should be empty string when disabled."
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when the module is disabled."
  }
}

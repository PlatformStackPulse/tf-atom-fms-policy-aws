# tf-atom-fms-policy-aws

[![Terraform Format](https://img.shields.io/badge/terraform-fmt-blue?logo=terraform)](https://github.com/PlatformStackPulse/tf-atom-fms-policy-aws/actions)
[![Terraform Validate](https://img.shields.io/badge/terraform-validate-blue?logo=terraform)](https://github.com/PlatformStackPulse/tf-atom-fms-policy-aws/actions)
[![TFLint](https://img.shields.io/badge/tflint-passing-brightgreen?logo=terraform)](https://github.com/PlatformStackPulse/tf-atom-fms-policy-aws/actions)
[![Terraform Test](https://img.shields.io/badge/tests-2%20passed-brightgreen?logo=terraform)](https://github.com/PlatformStackPulse/tf-atom-fms-policy-aws/actions)
[![Security Scan](https://img.shields.io/badge/trivy-passing-brightgreen?logo=aqua)](https://github.com/PlatformStackPulse/tf-atom-fms-policy-aws/actions)
[![Conventional Commits](https://img.shields.io/badge/commits-conventional-blue?logo=conventionalcommits)](https://conventionalcommits.org)
[![Documentation](https://img.shields.io/badge/docs-terraform--docs-blue?logo=readthedocs)](https://github.com/PlatformStackPulse/tf-atom-fms-policy-aws/actions)
[![License](https://img.shields.io/badge/license-MIT-blue?logo=opensourceinitiative)](LICENSE)

---

## Purpose

Terraform atom module that manages a single AWS Firewall Manager (FMS) policy — an organization-wide firewall policy for WAF/WAFv2, Shield Advanced, Security Groups, Network Firewall, DNS Firewall, or third-party firewalls.

## Architecture

```
Molecule Layer (consumers)
    |
    v
+-------------------+
| tf-atom-fms-policy-aws |
| (single resource) |
+-------------------+
    |
    v
AWS Provider
```

## Scope

| In Scope | Out of Scope |
|----------|-------------|
| Single resource lifecycle | Multi-resource orchestration (-> molecule) |
| Conditional creation (enabled flag) | Cross-service integration |
| Context propagation via tf-label | Monitoring and alerting |
| Input validation | IAM policy creation |

## Features

- Manages a single `aws_fms_policy` resource (atom pattern — one resource per module)
- Supports every FMS `policy_type` (WAF, WAFV2, SHIELD_ADVANCED, the SECURITY_GROUPS_* variants, NETWORK_FIREWALL, DNS_FIREWALL, THIRD_PARTY_FIREWALL, IMPORT_NETWORK_FIREWALL) with input validation
- Account-scoping via `include_account_ids` / `exclude_account_ids` (rendered as `include_map` / `exclude_map`)
- Resource targeting via `resource_type` or `resource_type_list`
- Remediation controls: `remediation_enabled`, `delete_all_policy_resources`, `delete_unused_fm_managed_resources`, `exclude_resource_tags`
- Consistent naming and tagging via tf-label (`module.this`); the policy name is the generated `id`
- Conditional creation with the `enabled` flag (creates nothing when `false`)
- Composable — designed to be consumed inside molecules
- Unit-tested with `terraform test` (mock provider) and security-scanned with Trivy

## Usage

```hcl
module "fms_policy" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-fms-policy-aws.git?ref=v1.0.0"

  namespace   = "eg"
  stage       = "prod"
  name        = "waf"

  policy_type         = "WAFV2"
  remediation_enabled = true

  managed_service_data = jsonencode({
    type                              = "WAFV2"
    preProcessRuleGroups              = []
    postProcessRuleGroups             = []
    defaultAction                     = { type = "ALLOW" }
    overrideCustomerWebACLAssociation = false
  })
}
```

## Module Documentation

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | git::https://github.com/PlatformStackPulse/tf-label.git | v1.0.0 |

### Resources

| Name | Type |
|------|------|
| [aws_fms_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fms_policy) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_policy_type"></a> [policy\_type](#input\_policy\_type) | Type of FMS policy. Valid values: WAF, WAFV2, SHIELD\_ADVANCED, SECURITY\_GROUPS\_COMMON, SECURITY\_GROUPS\_CONTENT\_AUDIT, SECURITY\_GROUPS\_USAGE\_AUDIT, NETWORK\_FIREWALL, DNS\_FIREWALL, THIRD\_PARTY\_FIREWALL, IMPORT\_NETWORK\_FIREWALL. | `string` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes and tags, which are merged. | <pre>object({<br/>    enabled             = optional(bool, true)<br/>    namespace           = optional(string, null)<br/>    tenant              = optional(string, null)<br/>    environment         = optional(string, null)<br/>    stage               = optional(string, null)<br/>    name                = optional(string, null)<br/>    delimiter           = optional(string, null)<br/>    attributes          = optional(list(string), [])<br/>    tags                = optional(map(string), {})<br/>    label_order         = optional(list(string), null)<br/>    regex_replace_chars = optional(string, null)<br/>    id_length_limit     = optional(number, null)<br/>    label_key_case      = optional(string, null)<br/>    label_value_case    = optional(string, null)<br/>    labels_as_tags      = optional(set(string), null)<br/>    descriptor_formats = optional(map(object({<br/>      format = string<br/>      labels = list(string)<br/>    })), {})<br/>  })</pre> | `{}` | no |
| <a name="input_delete_all_policy_resources"></a> [delete\_all\_policy\_resources](#input\_delete\_all\_policy\_resources) | Whether to delete all resources managed by this policy when deleting the policy. | `bool` | `false` | no |
| <a name="input_delete_unused_fm_managed_resources"></a> [delete\_unused\_fm\_managed\_resources](#input\_delete\_unused\_fm\_managed\_resources) | Whether to delete unused FM-managed resources. | `bool` | `false` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | <pre>map(object({<br/>    format = string<br/>    labels = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources. | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'. | `string` | `null` | no |
| <a name="input_exclude_account_ids"></a> [exclude\_account\_ids](#input\_exclude\_account\_ids) | List of AWS account IDs to exclude from the policy scope. | `list(string)` | `[]` | no |
| <a name="input_exclude_resource_tags"></a> [exclude\_resource\_tags](#input\_exclude\_resource\_tags) | Whether to exclude resources with specified tags. | `bool` | `false` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` to keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_include_account_ids"></a> [include\_account\_ids](#input\_include\_account\_ids) | List of AWS account IDs to include in the policy scope. | `list(string)` | `[]` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>Note: The value of the `name` tag, if included, will be the `id`, not the `name`. | `set(string)` | `null` | no |
| <a name="input_managed_service_data"></a> [managed\_service\_data](#input\_managed\_service\_data) | JSON-encoded managed service data for the policy. Structure depends on policy\_type. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique. | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_remediation_enabled"></a> [remediation\_enabled](#input\_remediation\_enabled) | Whether FMS should automatically remediate non-compliant resources. | `bool` | `false` | no |
| <a name="input_resource_type"></a> [resource\_type](#input\_resource\_type) | Resource type to protect. Use resource\_type OR resource\_type\_list, not both. | `string` | `null` | no |
| <a name="input_resource_type_list"></a> [resource\_type\_list](#input\_resource\_type\_list) | List of resource types to protect. | `list(string)` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element. A customer identifier, indicating who this instance of a resource is for. | `string` | `null` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the module is enabled. |
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | The ARN of the FMS Policy. |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | The ID of the FMS Policy. |
| <a name="output_policy_update_token"></a> [policy\_update\_token](#output\_policy\_update\_token) | The update token of the FMS Policy. |
<!-- END_TF_DOCS -->

## Tests

Unit tests live in `tests/unit/` and run against a mock AWS provider, so they make
no real AWS API calls and require no credentials. They assert on plan-known values
(the tf-label `id`, resource count, input pass-throughs, and the `enabled` flag).

```bash
# Run the unit tests
terraform init -backend=false
terraform test -test-directory=tests/unit

# Or via the Makefile
make test-unit
```

Integration tests (if present, under `tests/integration/`) exercise real AWS APIs and
require credentials; run them with `terraform test -test-directory=tests/integration`
or `make test-integration`.

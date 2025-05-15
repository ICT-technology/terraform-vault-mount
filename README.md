# Terraform Vault Mount Module

## Introduction

The `terraform-vault-mount` module provides a streamlined solution for managing HashiCorp Vault mounts (secret engines). This module enables you to define and configure mounts dynamically while ensuring compliance with Vault's best practices.

### Features

- **Dynamic Mount Management**: Supports the creation of mounts for KV, PKI, Transit, and other commonly used secret engines.
- **Flexible Configuration**: Configure Vault mount properties such as path, type, options, and lease durations.
- **Enterprise Namespace Support**: Compatible with Vault Enterprise namespaces.
- **DRY Design**: All mounts are managed dynamically with a clean and reusable Terraform configuration.

## Use Cases

- **Centralized Mount Management**: Consolidate and automate the management of all Vault mounts.
- **Multi-Engine Support**: Easily configure common engines such as KVv2, PKI, and Transit.
- **Namespace Provisioning**: Support enterprise deployments with namespace-specific mounts.

## Quick Start

Here is an example to get started with the module:

### Example Configuration

```hcl
module "vault_mounts" {
  source = "../../"

  mounts = {
    kvv2 = {
      path        = "kv-v2"
      type        = "kv-v2"
      description = "Key-Value Version 2 Secrets Engine"
      options     = { version = "2" }
    }

    pki = {
      path        = "pki"
      type        = "pki"
      description = "PKI Secrets Engine"
      default_lease_ttl_seconds = 3600
      max_lease_ttl_seconds     = 86400
    }

    transit = {
      path        = "transit"
      type        = "transit"
      description = "Transit Secrets Engine for Encryption-as-a-Service"
    }
  }
}
```

### Terraform Outputs

To retrieve mount accessors for the configured mounts:
```hcl
output "mount_accessors" {
  description = "The accessors for the configured Vault mounts."
  value       = module.vault_mounts.mount_accessor
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_mount.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mounts"></a> [mounts](#input\_mounts) | Defines the configurations for Vault mounts. Each mount configuration should specify the following keys:<br><br>  audit\_non\_hmac\_request\_keys : (Optional) Specifies the list of keys that will not be HMAC'd by audit devices in the request data object.<br><br>  audit\_non\_hmac\_response\_keys : (Optional) Specifies the list of keys that will not be HMAC'd by audit devices in the response data object.<br><br>  allowed\_managed\_keys : (Optional) Set of managed key registry entry names that the mount in question is allowed to access.<br><br>  default\_lease\_ttl\_seconds : (Optional) Default lease duration for tokens and secrets in seconds.<br><br>  description : (Optional) Human-friendly description of the mount.<br><br>  external\_entropy\_access : (Optional) Boolean flag that can be explicitly set to true to enable the secrets engine to access Vault's external entropy source.<br><br>  identity\_token\_key : (Optional) The key to use for signing plugin workload identity tokens. If not provided, this will default to Vault's OIDC default key.<br><br>  listing\_visibility : (Optional) Specifies whether to show this mount in the UI-specific listing endpoint. Valid values are `unauth` or `hidden`. If not set, behaves like `hidden`.<br><br>  local : (Optional) Boolean flag that can be explicitly set to true to enforce local mount in HA environment.<br><br>  max\_lease\_ttl\_seconds : (Optional) Maximum possible lease duration for tokens and secrets in seconds.<br><br>  namespace : (Optional) The namespace to provision the resource in. The value should not contain leading or trailing forward slashes. The namespace is always relative to the provider's configured namespace. Available only for Vault Enterprise.<br><br>  options : (Optional) Specifies mount type specific options that are passed to the backend.<br><br>  passthrough\_request\_headers : (Optional) List of headers to allow and pass from the request to the plugin.<br><br>  plugin\_version : (Optional) Specifies the semantic version of the plugin to use, e.g. "v1.0.0". If unspecified, the server will select the latest versioned or built-in plugin.<br><br>  seal\_wrap : (Optional) Boolean flag that can be explicitly set to true to enable seal wrapping for the mount, causing values stored by the mount to be wrapped by the seal's encryption capability.<br><br>  allowed\_response\_headers : (Optional) List of headers to allow, allowing a plugin to include them in the response.<br><br>  delegated\_auth\_accessors : (Optional) List of allowed authentication mount accessors the backend can request delegated authentication for.<br><br>  path : (Required) Where the secret backend will be mounted.<br><br>  type : (Required) Type of the backend, such as "aws".<br> | <pre>map(object({<br>    audit_non_hmac_request_keys  = optional(list(string))<br>    audit_non_hmac_response_keys = optional(list(string))<br>    allowed_managed_keys         = optional(set(string))<br>    default_lease_ttl_seconds    = optional(number)<br>    description                  = optional(string)<br>    external_entropy_access      = optional(bool)<br>    identity_token_key           = optional(string)<br>    listing_visibility           = optional(string)<br>    local                        = optional(bool)<br>    max_lease_ttl_seconds        = optional(number)<br>    namespace                    = optional(string)<br>    options                      = optional(map(any))<br>    passthrough_request_headers  = optional(list(string))<br>    plugin_version               = optional(string)<br>    seal_wrap                    = optional(bool)<br>    allowed_response_headers     = optional(list(string))<br>    delegated_auth_accessors     = optional(list(string))<br>    path                         = string<br>    type                         = string<br>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mount_accessor"></a> [mount\_accessor](#output\_mount\_accessor) | The accessor for this mount. |
<!-- END_TF_DOCS -->

## Software Bill of Materials (SBOM)

This module provides a Software Bill of Materials (SBOM) following the **CycloneDX** standard.

The SBOM contains a comprehensive inventory of components and dependencies used in this module, ensuring transparency and compliance with software supply chain security requirements.

- [Download the SBOM (JSON format)](sbom/SBOM-terraform-vault-mount-v2025.1.3-cyclonedx.json)

To verify the SBOM signatures:
```bash
cyclonedx verify all /sboms/SBOM-terraform-vault-mount-v2025.1.3-cyclonedx.xml --key-file /sboms/sbom-public-key.pem
```

## Author

This module is maintained by **Ralf Ramge, ICT.technology KLG**. For more information, contact us at [ralf.ramge@ict.technology](mailto:ralf.ramge@ict.technology) or visit us at [ICT.technology KLG Homepage](https://ict.technology).

### BEGIN FILE: docs/resources/vault_mount.html.markdown ###

---
layout: "vault"
page_title: "Vault: vault_mount resource"
sidebar_current: "docs-vault-resource-mount"
description: |-
  Managing the mounting of secret backends in Vault
---

# vault\_mount

This resource enables a new secrets engine at the given path.

## Example Usage

```hcl
resource "vault_mount" "example" {
  path        = "dummy"
  type        = "generic"
  description = "This is an example mount"
}
```

```hcl
resource "vault_mount" "kvv2-example" {
  path        = "version2-example"
  type        = "kv-v2"
  options = {
    version = "2"
    type    = "kv-v2"
  }
  description = "This is an example KV Version 2 secret engine mount"
}
```

```hcl
resource "vault_mount" "transit-example" {
  path        = "transit-example"
  type        = "transit"
  description = "This is an example transit secret engine mount"

  options = {
    convergent_encryption = false
  }
}
```

```hcl
resource "vault_mount" "pki-example" {
  path        = "pki-example"
  type        = "pki"
  description = "This is an example PKI mount"

  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}
```

## Argument Reference

The following arguments are supported:

* `namespace` - (Optional) The namespace to provision the resource in.
  The value should not contain leading or trailing forward slashes.
  The `namespace` is always relative to the provider's configured [namespace](/docs/providers/vault/index.html#namespace).
   *Available only for Vault Enterprise*.

* `path` - (Required) Where the secret backend will be mounted

* `type` - (Required) Type of the backend, such as "aws"

* `description` - (Optional) Human-friendly description of the mount

* `default_lease_ttl_seconds` - (Optional) Default lease duration for tokens and secrets in seconds

* `max_lease_ttl_seconds` - (Optional) Maximum possible lease duration for tokens and secrets in seconds

* `audit_non_hmac_response_keys` - (Optional) Specifies the list of keys that will not be HMAC'd by audit devices in the response data object.

* `audit_non_hmac_request_keys` - (Optional) Specifies the list of keys that will not be HMAC'd by audit devices in the request data object.

* `local` - (Optional) Boolean flag that can be explicitly set to true to enforce local mount in HA environment

* `options` - (Optional) Specifies mount type specific options that are passed to the backend

* `seal_wrap` - (Optional) Boolean flag that can be explicitly set to true to enable seal wrapping for the mount, causing values stored by the mount to be wrapped by the seal's encryption capability

* `external_entropy_access` - (Optional) Boolean flag that can be explicitly set to true to enable the secrets engine to access Vault's external entropy source

* `allowed_managed_keys` - (Optional) Set of managed key registry entry names that the mount in question is allowed to access

* `listing_visibility` - (Optional) Specifies whether to show this mount in the UI-specific
  listing endpoint. Valid values are `unauth` or `hidden`. If not set, behaves like `hidden`.

* `passthrough_request_headers` - (Optional) List of headers to allow and pass from the request to
  the plugin.

* `allowed_response_headers` - (Optional) List of headers to allow, allowing a plugin to include
  them in the response.

* `delegated_auth_accessors` - (Optional)  List of allowed authentication mount accessors the
  backend can request delegated authentication for.

* `plugin_version` - (Optional) Specifies the semantic version of the plugin to use, e.g. "v1.0.0".
  If unspecified, the server will select any matching unversioned plugin that may have been
  registered, the latest versioned plugin registered, or a built-in plugin in that order of precedence.

* `identity_token_key` - (Optional)  The key to use for signing plugin workload identity tokens. If
  not provided, this will default to Vault's OIDC default key.

## Attributes Reference

In addition to the fields above, the following attributes are exported:

* `accessor` - The accessor for this mount.

## Import

Mounts can be imported using the `path`, e.g.

```
$ terraform import vault_mount.example dummy
```

### END FILE: docs/resources/vault_mount.html.markdown ###

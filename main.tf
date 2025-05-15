### BEGIN FILE: main.tf ###

resource "vault_mount" "this" {
  for_each = var.mounts != null ? var.mounts : {}

  lifecycle {
    # This precondition ensures that KV-v2 mounts have the correct options set.
    # This is a runtime check rather than a variable validation because it requires
    # cross-field validation between 'type' and 'options', which is more appropriate
    # at runtime to catch configuration errors that could lead to incorrect mount setup.
    precondition {
      condition = each.value["type"] != "kv-v2" || (
        each.value["options"] == null ||
        (each.value["options"] != null &&
          (try(each.value["options"]["version"], null) == null ||
          try(each.value["options"]["version"], null) == "2")
        )
      )
      error_message = "For KV-v2 mounts, the 'options.version' must be set to '2' or not specified."
    }

    # This precondition ensures that path names don't contain special characters that could
    # cause issues with Vault's API. This is a runtime check because it's a critical operational
    # requirement that goes beyond simple format validation.
    precondition {
      condition     = can(regex("^[a-zA-Z0-9-_/]+$", each.value["path"]))
      error_message = "Mount path must only contain alphanumeric characters, hyphens, underscores, or forward slashes."
    }

    # This precondition ensures that when both TTL values are specified, max_lease_ttl is greater than or equal to default_lease_ttl.
    # While this is already covered in variable validation, implementing it as a runtime check provides an additional safety layer
    # for cases where the values might be derived from other resources or data sources at runtime.
    precondition {
      condition = (
        each.value["default_lease_ttl_seconds"] == null ||
        each.value["max_lease_ttl_seconds"] == null ||
        each.value["max_lease_ttl_seconds"] >= each.value["default_lease_ttl_seconds"]
      )
      error_message = "The max_lease_ttl_seconds must be greater than or equal to default_lease_ttl_seconds when both are specified."
    }

    # This precondition ensures that PKI mounts have appropriate TTL settings.
    # This is a runtime check because PKI certificates have specific requirements for TTL values
    # that are critical for operational security and can't be fully validated at variable definition time.
    precondition {
      condition = (
        each.value["type"] != "pki" ||
        each.value["max_lease_ttl_seconds"] == null ||
        each.value["max_lease_ttl_seconds"] > 0
      )
      error_message = "PKI mounts require a positive max_lease_ttl_seconds value to define the maximum certificate lifetime."
    }

    # This postcondition verifies that the mount was successfully created and has an accessor.
    # This is important to confirm at runtime that the mount is operational.
    postcondition {
      condition     = self.accessor != null && self.accessor != ""
      error_message = "Failed to obtain a valid accessor for the mount, which indicates the mount may not have been created properly."
    }

    # This postcondition verifies that paths are unique across all mounts.
    # This is a runtime check because it requires evaluating the entire collection of mounts
    # to ensure there are no duplicates, which can't be done in variable validation.
    postcondition {
      condition = (
        length([
          for k, v in var.mounts : v["path"] if v["path"] == self.path
        ]) == 1
      )
      error_message = "Duplicate mount paths detected. Each mount must have a unique path."
    }

  }

  audit_non_hmac_request_keys  = each.value["audit_non_hmac_request_keys"]
  audit_non_hmac_response_keys = each.value["audit_non_hmac_response_keys"]
  allowed_managed_keys         = each.value["allowed_managed_keys"]
  default_lease_ttl_seconds    = each.value["default_lease_ttl_seconds"]
  description                  = each.value["description"]
  external_entropy_access      = each.value["external_entropy_access"]
  identity_token_key           = each.value["identity_token_key"]
  listing_visibility           = each.value["listing_visibility"]
  local                        = each.value["local"]
  max_lease_ttl_seconds        = each.value["max_lease_ttl_seconds"]
  namespace                    = each.value["namespace"] != null ? trim(each.value["namespace"], "/") : null
  options                      = each.value["options"]
  passthrough_request_headers  = each.value["passthrough_request_headers"]
  allowed_response_headers     = each.value["allowed_response_headers"]
  plugin_version               = each.value["plugin_version"]
  delegated_auth_accessors     = each.value["delegated_auth_accessors"]
  path                         = each.value["path"]
  seal_wrap                    = each.value["seal_wrap"]
  type                         = each.value["type"]
}

### END FILE: main.tf ###

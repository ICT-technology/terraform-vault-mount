### BEGIN FILE: tests/complete.tftest.hcl ###

#
# Test with a complete configuration using all possible parameters
run "complete_mount_configuration" {
  command = plan

  variables {
    mounts = {
      "complete_mount" = {
        path                         = "complete"
        type                         = "kv"
        audit_non_hmac_request_keys  = ["key1", "key2"]
        audit_non_hmac_response_keys = ["resp1", "resp2"]
        allowed_managed_keys         = ["managed1", "managed2"]
        default_lease_ttl_seconds    = 3600
        description                  = "Complete test mount"
        external_entropy_access      = true
        identity_token_key           = "identity-key"
        listing_visibility           = "unauth"
        local                        = true
        max_lease_ttl_seconds        = 86400
        options                      = { version = "1" }
        passthrough_request_headers  = ["X-Custom-Header"]
        allowed_response_headers     = ["X-Response-Header"]
        plugin_version               = "v1.0.0"
        seal_wrap                    = true
      }
    }
  }

  assert {
    condition     = vault_mount.this["complete_mount"].path == "complete"
    error_message = "Path not set correctly"
  }

  assert {
    condition     = vault_mount.this["complete_mount"].type == "kv"
    error_message = "Type not set correctly"
  }

  assert {
    condition     = vault_mount.this["complete_mount"].description == "Complete test mount"
    error_message = "Description not set correctly"
  }

  assert {
    condition     = vault_mount.this["complete_mount"].listing_visibility == "unauth"
    error_message = "Listing visibility not set correctly"
  }
}

### END FILE: tests/complete.tftest.hcl ###

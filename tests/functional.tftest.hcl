### BEGIN FILE: tests/functional.tftest.hcl ###


# Test 1: Basic mount creation
run "basic_mount_creation" {
  command = plan

  variables {
    mounts = {
      "test_mount" = {
        path        = "test-path"
        type        = "kv"
        description = "Test mount"
      }
    }
  }

  assert {
    condition     = length(vault_mount.this) == 1
    error_message = "Expected one mount to be created"
  }
}

# Test 2: Multiple mounts creation
run "multiple_mounts_creation" {
  command = plan

  variables {
    mounts = {
      "test_mount1" = {
        path        = "test-path1"
        type        = "kv"
        description = "Test mount 1"
      },
      "test_mount2" = {
        path        = "test-path2"
        type        = "transit"
        description = "Test mount 2"
      }
    }
  }

  assert {
    condition     = length(vault_mount.this) == 2
    error_message = "Expected two mounts to be created"
  }
}

# Test 3: KV-V2 mount creation
run "kv_v2_mount_creation" {
  command = plan

  variables {
    mounts = {
      "kv_mount" = {
        path = "secrets"
        type = "kv-v2"
        options = {
          version = "2"
        }
      }
    }
  }

  assert {
    condition     = vault_mount.this["kv_mount"].type == "kv-v2"
    error_message = "Expected type to be kv-v2"
  }
}

# Test 4: PKI mount with TTL settings
run "pki_mount_with_ttl" {
  command = plan

  variables {
    mounts = {
      "pki_mount" = {
        path                      = "pki"
        type                      = "pki"
        default_lease_ttl_seconds = 3600
        max_lease_ttl_seconds     = 86400
      }
    }
  }

  assert {
    condition     = vault_mount.this["pki_mount"].default_lease_ttl_seconds == 3600
    error_message = "Expected default_lease_ttl_seconds to be 3600"
  }

  assert {
    condition     = vault_mount.this["pki_mount"].max_lease_ttl_seconds == 86400
    error_message = "Expected max_lease_ttl_seconds to be 86400"
  }
}

# Test 5: Mount with namespace
run "mount_with_namespace" {
  command = plan

  variables {
    mounts = {
      "namespaced_mount" = {
        path      = "namespaced-path"
        type      = "kv"
        namespace = "my-namespace"
      }
    }
  }

  assert {
    condition     = vault_mount.this["namespaced_mount"].namespace == "my-namespace"
    error_message = "Expected namespace to be my-namespace"
  }
}

### END FILE: tests/functional.tftest.hcl ###

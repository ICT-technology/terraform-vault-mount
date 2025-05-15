### BEGIN FILE: tests/contract.tftest.hcl ###

mock_provider "vault" {}

# Test 1: Valid basic configuration
run "valid_basic_configuration" {
  command = plan

  variables {
    mounts = {
      "example_mount" = {
        path = "example"
        type = "kv"
      }
    }
  }
}

# Test 2: Valid KV-V2 configuration
run "valid_kv_v2_configuration" {
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
}

# Test 3: Testing path validation - invalid path with leading slash
run "invalid_path_leading_slash" {
  command = plan

  variables {
    mounts = {
      "invalid_mount" = {
        path = "/invalid"
        type = "kv"
      }
    }
  }

  expect_failures = [
    var.mounts,
  ]
}

# Test 4: Testing path validation - invalid path with trailing slash
run "invalid_path_trailing_slash" {
  command = plan

  variables {
    mounts = {
      "invalid_mount" = {
        path = "invalid/"
        type = "kv"
      }
    }
  }

  expect_failures = [
    var.mounts,
  ]
}

# Test 5: Testing path validation - invalid characters
run "invalid_path_characters" {
  command = plan

  variables {
    mounts = {
      "invalid_mount" = {
        path = "invalid@path"
        type = "kv"
      }
    }
  }

  expect_failures = [
    var.mounts,
  ]
}

# Test 6: Testing lease TTL validations - max TTL less than default TTL
run "invalid_lease_ttl_relationship" {
  command = plan

  variables {
    mounts = {
      "invalid_mount" = {
        path                      = "invalid"
        type                      = "kv"
        default_lease_ttl_seconds = 3600
        max_lease_ttl_seconds     = 1800
      }
    }
  }

  expect_failures = [
    var.mounts,
  ]
}

# Test 7: Testing listing_visibility validation - invalid value
run "invalid_listing_visibility" {
  command = plan

  variables {
    mounts = {
      "invalid_mount" = {
        path               = "invalid"
        type               = "kv"
        listing_visibility = "invalid"
      }
    }
  }

  expect_failures = [
    var.mounts,
  ]
}

# Test 8: Testing KV-V2 options validation - invalid version
run "invalid_kv_v2_version" {
  command = plan

  variables {
    mounts = {
      "invalid_mount" = {
        path = "invalid"
        type = "kv-v2"
        options = {
          version = "1"
        }
      }
    }
  }

  expect_failures = [
    var.mounts,
  ]
}

### END FILE: tests/contract.tftest.hcl ###

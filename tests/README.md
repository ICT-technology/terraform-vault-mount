# Terraform Vault Mount Module Tests

This directory contains tests for the `terraform-vault-mount` module using Terraform's built-in testing framework. These tests validate the module's functionality without requiring a real Vault server.

## Overview

The test suite consists of:

- **Contract tests**: Validates variable constraints and validations
- **Functional tests**: Verifies resource creation with different configurations
- **Complete configuration test**: Tests a comprehensive configuration with all parameters
- **Mock resources**: Defines mock data for Vault resources

## Prerequisites

- Terraform v1.12+ (Required for the built-in test framework)
- No real Vault instance is required as all tests use mock providers

## Running Tests

From the module's root directory, run:

```bash
# Run all tests
terraform test

# Run a specific test file
terraform test -filter=contract.tftest.hcl

# Run tests with verbose output
terraform test -verbose
```

## Test Files

### 1. contract.tftest.hcl

Tests variable validations and constraints to ensure the module correctly rejects invalid configurations:

- Valid basic and KV-V2 configurations
- Path format validations (leading/trailing slashes, invalid characters)
- TTL relationship validations
- Listing visibility validation
- KV-V2 version validation

### 2. functional.tftest.hcl

Tests the module's functional aspects:

- Basic mount creation
- Multiple mounts creation
- KV-V2 specific configuration 
- PKI mount with TTL settings
- Mounts with namespaces

### 3. complete.tftest.hcl

Tests a comprehensive configuration that uses all supported parameters to ensure the module can handle complex real-world scenarios.

### 4. vault.tfmock.hcl

Contains mock resource definitions for Vault resources:

```hcl
mock_resource "vault_mount" {
  defaults = {
    accessor = "mock-accessor-value"
    path     = "mock-path"
  }
}
```

This mockup allows tests to run without a real Vault server by providing predefined values for computed attributes.

## Design Principles

1. **Isolation**: Tests do not require real infrastructure
2. **Completeness**: Tests cover both happy paths and error cases
3. **Validation**: Tests verify both variable validations and resource configurations
4. **Independence**: Each test case operates independently

## Adding New Tests

When adding new tests:

1. Choose the appropriate test file based on what you're testing
2. Use descriptive run block names
3. Add appropriate assertions or expect_failures blocks
4. Extend the mock resources if needed to support new functionalities

## Notes

- Some assertions rely on the mock provider returning specified default values
- The tests focus on validations and configurations rather than actual Vault behavior
- Postconditions in the module that check runtime behavior may not be fully testable with mocks

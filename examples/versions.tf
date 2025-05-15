### BEGIN FILE: examples/versions.tf ###

terraform {
  required_version = ">= 1.10"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4"
    }
  }
}

### END FILE: examples/versions.tf ###

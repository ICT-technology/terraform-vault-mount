### BEGIN FILE: versions.tf ###

terraform {
  required_version = ">= 1.12"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4"
    }
  }
}

### END FILE: versions.tf ###

### BEGIN FILE: examples/main.tf ###

module "vault_mounts" {
  source = "./../"

  mounts = {
    kvv2 = {
      path        = "kv-v2"
      type        = "kv-v2"
      description = "Key-Value Version 2 Secrets Engine"
      options     = { version = "2" }
    }

    pki = {
      path                      = "pki"
      type                      = "pki"
      description               = "PKI Secrets Engine"
      default_lease_ttl_seconds = 3600
      max_lease_ttl_seconds     = 86400
    }

    kubernetes = {
      path        = "kubernetes"
      type        = "kubernetes"
      description = "Kubernetes Auth Engine"
    }

    ldap = {
      path        = "ldap"
      type        = "ldap"
      description = "LDAP Auth Engine"
      options     = { case_sensitive_names = "true" }
    }

    transit = {
      path        = "transit"
      type        = "transit"
      description = "Transit Secrets Engine for Encryption-as-a-Service"
      options = {
        convergent_encryption = false
      }
    }

    aws = {
      path        = "aws"
      type        = "aws"
      description = "AWS Secrets Engine"
    }
  }
}


### END FILE: examples/main.tf ###

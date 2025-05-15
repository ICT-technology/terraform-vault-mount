### BEGIN FILE: examples/outputs.tf ###

output "mount_accessors" {
  description = "Accessors for the configured Vault mounts"
  value       = module.vault_mounts.mount_accessor
}

### END FILE: examples/outputs.tf ###

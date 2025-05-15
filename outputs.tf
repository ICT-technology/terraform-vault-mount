### BEGIN FILE: outputs.tf ###

output "mount_accessor" {
  description = "The accessor for this mount."
  value       = { for k, v in vault_mount.this : k => v.accessor }
}

### END FILE: outputs.tf ###

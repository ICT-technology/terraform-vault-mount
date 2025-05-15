### BEGIN FILE: variables.tf ###

variable "mounts" {
  type = map(object({
    audit_non_hmac_request_keys  = optional(list(string))
    audit_non_hmac_response_keys = optional(list(string))
    allowed_managed_keys         = optional(set(string))
    default_lease_ttl_seconds    = optional(number)
    description                  = optional(string)
    external_entropy_access      = optional(bool)
    identity_token_key           = optional(string)
    listing_visibility           = optional(string)
    local                        = optional(bool)
    max_lease_ttl_seconds        = optional(number)
    namespace                    = optional(string)
    options                      = optional(map(any))
    passthrough_request_headers  = optional(list(string))
    plugin_version               = optional(string)
    seal_wrap                    = optional(bool)
    allowed_response_headers     = optional(list(string))
    delegated_auth_accessors     = optional(list(string))
    path                         = string
    type                         = string
  }))
  default = null

  description = <<-EOT
Defines the configurations for Vault mounts. Each mount configuration should specify the following keys:<br>
  audit_non_hmac_request_keys : (Optional) Specifies the list of keys that will not be HMAC'd by audit devices in the request data object.<br>
  audit_non_hmac_response_keys : (Optional) Specifies the list of keys that will not be HMAC'd by audit devices in the response data object.<br>
  allowed_managed_keys : (Optional) Set of managed key registry entry names that the mount in question is allowed to access.<br>
  default_lease_ttl_seconds : (Optional) Default lease duration for tokens and secrets in seconds.<br>
  description : (Optional) Human-friendly description of the mount.<br>
  external_entropy_access : (Optional) Boolean flag that can be explicitly set to true to enable the secrets engine to access Vault's external entropy source.<br>
  identity_token_key : (Optional) The key to use for signing plugin workload identity tokens. If not provided, this will default to Vault's OIDC default key.<br>
  listing_visibility : (Optional) Specifies whether to show this mount in the UI-specific listing endpoint. Valid values are `unauth` or `hidden`. If not set, behaves like `hidden`.<br>
  local : (Optional) Boolean flag that can be explicitly set to true to enforce local mount in HA environment.<br>
  max_lease_ttl_seconds : (Optional) Maximum possible lease duration for tokens and secrets in seconds.<br>
  namespace : (Optional) The namespace to provision the resource in. The value should not contain leading or trailing forward slashes. The namespace is always relative to the provider's configured namespace. Available only for Vault Enterprise.<br>
  options : (Optional) Specifies mount type specific options that are passed to the backend.<br>
  passthrough_request_headers : (Optional) List of headers to allow and pass from the request to the plugin.<br>
  plugin_version : (Optional) Specifies the semantic version of the plugin to use, e.g. "v1.0.0". If unspecified, the server will select the latest versioned or built-in plugin.<br>
  seal_wrap : (Optional) Boolean flag that can be explicitly set to true to enable seal wrapping for the mount, causing values stored by the mount to be wrapped by the seal's encryption capability.<br>
  allowed_response_headers : (Optional) List of headers to allow, allowing a plugin to include them in the response.<br>
  delegated_auth_accessors : (Optional) List of allowed authentication mount accessors the backend can request delegated authentication for.<br>
  path : (Required) Where the secret backend will be mounted.<br>
  type : (Required) Type of the backend, such as "aws".<br>
EOT

  validation {
    condition = (
      var.mounts == null ? true : alltrue([
        for mount in var.mounts : (
          mount.listing_visibility == null ||
          mount.listing_visibility == "unauth" ||
          mount.listing_visibility == "hidden"
        )
      ])
    )
    error_message = "The 'listing_visibility' value must be either 'unauth' or 'hidden' if specified."
  }

  validation {
    condition = (
      var.mounts == null ? true : alltrue([
        for mount in var.mounts : (
          lower(mount.type) != "kv-v2" || (
            mount.options == null || (
              try(mount.options["version"], null) == null ||
              try(mount.options["version"], null) == "2"
            )
          )
        )
      ])
    )
    error_message = "For KV-v2 mounts, the 'options.version' must be set to '2' or not specified."
  }

  validation {
    condition = (
      var.mounts == null ? true : alltrue([
        for mount in var.mounts : (
          mount.path == null || (
            !startswith(mount.path, "/") &&
            !endswith(mount.path, "/")
          )
        )
      ])
    )
    error_message = "The 'path' value must not start or end with a '/'."
  }

  validation {
    condition = (
      var.mounts == null ? true : alltrue([
        for mount in var.mounts : (
          can(regex("^[a-zA-Z0-9-_/]+$", mount.path))
        )
      ])
    )
    error_message = "The 'path' value must only contain alphanumeric characters, hyphens, underscores, or forward slashes."
  }


  validation {
    condition = (
      var.mounts == null ? true : alltrue([
        for mount in var.mounts : (
          mount.plugin_version == null || (
            substr(mount.plugin_version != null ? mount.plugin_version : " ", 0, 1) == "v" &&
            length(split(".", mount.plugin_version != null ? mount.plugin_version : "")) == 3
          )
        )
      ])
    )
    error_message = "The 'plugin_version', if specified, must start with 'v' and follow semantic versioning, e.g., 'v1.0.0'."
  }

  validation {
    condition = (
      var.mounts == null ? true : alltrue([
        for mount in var.mounts : (
          mount.type != null && length(mount.type) > 0
        )
      ])
    )
    error_message = "The 'type' value cannot be null or empty. It is a required field."
  }

  validation {
    condition = (
      var.mounts == null ? true : alltrue([
        for mount in var.mounts : (
          mount.options == null || can(mount.options)
        )
      ])
    )
    error_message = "The 'options' field, if specified, must be a map."
  }

  validation {
    condition = (
      var.mounts == null ? true : alltrue([
        for mount in var.mounts : (
          mount.default_lease_ttl_seconds == null ? true : mount.default_lease_ttl_seconds > 0
        )
      ])
    )
    error_message = "The 'default_lease_ttl_seconds' must be a positive number when specified."
  }

  validation {
    condition = (
      var.mounts == null ? true : alltrue([
        for mount in var.mounts : (
          mount.max_lease_ttl_seconds == null ? true : mount.max_lease_ttl_seconds > 0
        )
      ])
    )
    error_message = "The 'max_lease_ttl_seconds' must be a positive number when specified."
  }

  validation {
    condition = (
      var.mounts == null ? true : alltrue([
        for mount in var.mounts : (
          mount.default_lease_ttl_seconds == null || mount.max_lease_ttl_seconds == null ? true :
          mount.max_lease_ttl_seconds >= mount.default_lease_ttl_seconds
        )
      ])
    )
    error_message = "The 'max_lease_ttl_seconds' must be greater than or equal to 'default_lease_ttl_seconds' when both are specified."
  }


}


### END FILE: variables.tf ###

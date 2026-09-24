variable "file_system_id" {
  default     = null
  description = "The ID of the EFS file system for which to create the access point."
}

variable "posix_user" {
  default     = null
  description = "POSIX user enforced for all file system requests made through this access point. If null, no POSIX user is enforced."
  type = object({
    uid            = optional(number, 1000)
    gid            = optional(number, 1000)
    secondary_gids = optional(list(number))
  })
}

variable "root_directory" {
  default     = null
  description = "Root directory configuration for the access point. If null, the root of the file system ('/') is exposed with no creation info."
  type = object({
    path = optional(string)
    creation_info = optional(object({
      owner_uid   = optional(number, 1000)
      owner_gid   = optional(number, 1000)
      permissions = optional(string, "0755")
    }))
  })
}

variable "tags" {
  default     = null
  description = "A map of tags to assign to the access point."
}

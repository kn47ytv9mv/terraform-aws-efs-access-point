resource "aws_efs_access_point" "resource" {
  file_system_id = var.file_system_id

  dynamic "posix_user" {
    for_each = var.posix_user[*]

    content {
      uid            = posix_user.value.uid
      gid            = posix_user.value.gid
      secondary_gids = posix_user.value.secondary_gids
    }
  }

  dynamic "root_directory" {
    for_each = var.root_directory[*]

    content {
      path = root_directory.value.path

      dynamic "creation_info" {
        for_each = root_directory.value.creation_info[*]

        content {
          owner_uid   = creation_info.value.owner_uid
          owner_gid   = creation_info.value.owner_gid
          permissions = creation_info.value.permissions
        }
      }
    }
  }

  tags = var.tags
}

output "id" {
  description = "The ID of the access point."
  value       = aws_efs_access_point.resource.id
}

output "arn" {
  description = "The ARN of the access point."
  value       = aws_efs_access_point.resource.arn
}

output "file_system_arn" {
  description = "The ARN of the EFS file system that the access point applies to."
  value       = aws_efs_access_point.resource.file_system_arn
}

output "owner_id" {
  description = "The AWS account ID that owns the access point."
  value       = aws_efs_access_point.resource.owner_id
}

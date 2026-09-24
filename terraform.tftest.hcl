mock_provider "aws" {
}

run "default_no_posix_user_or_root_directory" {
  command = plan

  variables {
    file_system_id = "fs-0123456789abcdef0"
  }

  assert {
    condition     = length(aws_efs_access_point.resource.posix_user) == 0
    error_message = "posix_user is null by default, so the dynamic block should not be generated."
  }

  assert {
    condition     = length(aws_efs_access_point.resource.root_directory) == 0
    error_message = "root_directory is null by default, so the dynamic block should not be generated."
  }
}

run "posix_user_defaults_fire_only_when_object_passed" {
  command = plan

  variables {
    file_system_id = "fs-0123456789abcdef0"

    posix_user = {}
  }

  assert {
    condition     = aws_efs_access_point.resource.posix_user[0].uid == 1000
    error_message = "posix_user.uid should default to 1000 when an empty object is passed."
  }

  assert {
    condition     = aws_efs_access_point.resource.posix_user[0].gid == 1000
    error_message = "posix_user.gid should default to 1000 when an empty object is passed."
  }
}

run "posix_user_custom_values" {
  command = plan

  variables {
    file_system_id = "fs-0123456789abcdef0"

    posix_user = {
      uid            = 2000
      gid            = 2000
      secondary_gids = [2001]
    }
  }

  assert {
    condition     = aws_efs_access_point.resource.posix_user[0].uid == 2000
    error_message = "An explicit uid should override the default."
  }

  assert {
    condition     = aws_efs_access_point.resource.posix_user[0].secondary_gids == toset([2001])
    error_message = "secondary_gids should be passed through."
  }
}

run "root_directory_creation_info_defaults" {
  command = plan

  variables {
    file_system_id = "fs-0123456789abcdef0"

    root_directory = {
      creation_info = {}
    }
  }

  assert {
    condition     = aws_efs_access_point.resource.root_directory[0].creation_info[0].owner_uid == 1000
    error_message = "creation_info.owner_uid should default to 1000 when an empty object is passed."
  }

  assert {
    condition     = aws_efs_access_point.resource.root_directory[0].creation_info[0].permissions == "0755"
    error_message = "creation_info.permissions should default to '0755'."
  }
}

run "root_directory_custom_values" {
  command = plan

  variables {
    file_system_id = "fs-0123456789abcdef0"

    root_directory = {
      path = "/example"
      creation_info = {
        owner_uid   = 2000
        owner_gid   = 2000
        permissions = "0750"
      }
    }
  }

  assert {
    condition     = aws_efs_access_point.resource.root_directory[0].path == "/example"
    error_message = "An explicit path should be passed through."
  }

  assert {
    condition     = aws_efs_access_point.resource.root_directory[0].creation_info[0].permissions == "0750"
    error_message = "An explicit permissions value should override the default."
  }
}

run "readme_default_minimal" {
  command = plan

  variables {
    file_system_id = "fs-0123456789abcdef0"
  }
}

run "readme_posix_user_and_root_directory_defaults" {
  command = plan

  variables {
    file_system_id = "fs-0123456789abcdef0"

    root_directory = {
      creation_info = {}
    }

    posix_user = {}
  }
}

run "readme_custom_values" {
  command = plan

  variables {
    file_system_id = "fs-0123456789abcdef0"

    root_directory = {
      path = "/example"

      creation_info = {
        owner_uid   = 2000
        owner_gid   = 2000
        permissions = "0750"
      }
    }

    posix_user = {
      uid            = 2000
      gid            = 2000
      secondary_gids = [2001]
    }
  }
}

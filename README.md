# terraform-aws-efs-access-point

Terraform module for an EFS Access Point, with optional POSIX user
enforcement and an optional managed root directory.

## Cost

EFS Access Points carry no charge of their own — cost comes from the
underlying file system's storage and throughput.

## Usage

```hcl
module "access_point" {
  source = "kn47ytv9mv/efs-access-point/aws"

  file_system_id = module.efs.id
}
```

Or directly from this repository:

```hcl
module "access_point" {
  source = "github.com/kn47ytv9mv/terraform-aws-efs-access-point"

  file_system_id = module.efs.id
}
```

With a POSIX user and managed root directory, using their defaults
(`uid`/`gid`/`owner_uid`/`owner_gid` of `1000`, `permissions` of `0755`):

```hcl
module "access_point" {
  source = "kn47ytv9mv/efs-access-point/aws"

  file_system_id = module.efs.id

  root_directory = {
    creation_info = {}
  }

  posix_user = {}
}
```

With custom values:

```hcl
module "access_point" {
  source = "kn47ytv9mv/efs-access-point/aws"

  file_system_id = module.efs.id

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
```

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.3 |
| aws | ~> 6.61 |

## Providers

| Name | Version |
|---|---|
| aws | ~> 6.61 |

## Inputs

| Name | Description | Default | Required |
|---|---|---|---|
| file_system_id | The ID of the EFS file system for which to create the access point. | `null` | no |
| posix_user | POSIX user enforced for all file system requests made through this access point (`uid` and `gid` default to `1000`, optional `secondary_gids`). If null, no POSIX user is enforced. | `null` | no |
| root_directory | Root directory configuration for the access point (`path`, optional `creation_info` with `owner_uid`/`owner_gid` defaulting to `1000` and `permissions` defaulting to `"0755"`). If null, the root of the file system (`/`) is exposed with no creation info. | `null` | no |
| tags | A map of tags to assign to the access point. | `null` | no |

## Outputs

| Name | Description |
|---|---|
| id | The ID of the access point. |
| arn | The ARN of the access point. |
| file_system_arn | The ARN of the EFS file system that the access point applies to. |
| owner_id | The AWS account ID that owns the access point. |

## License

MIT — see [LICENSE.md](LICENSE.md).

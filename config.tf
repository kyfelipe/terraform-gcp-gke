data "local_file" "_defaults" {
  filename = "${path.module}/config/_defaults.yml"
}

locals {
  config = yamldecode(data.local_file._defaults.content)
}

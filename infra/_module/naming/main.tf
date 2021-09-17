variable "role" {
  type = string
}

locals {
  name = "${terraform.workspace}-${var.role}"
}

output "name" {
  value = local.name
}

output "tags" {
  value = {
    Name    = local.name
    Env     = terraform.workspace
    Managed = "Terraform"
  }
}

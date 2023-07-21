provider "vault" {
  address = var.vault_address
}

resource "vault_policy" "users" {
  name   = "users-policy"
  policy = <<EOT
    path "secret/data/users" {
      capabilities = ["create", "read", "update", "delete", "list"]
    }
  EOT
}

# resource "vault_auth_backend" "userpass" {
#   type = "userpass"
#   path = "userpass"
# }

# resource "vault_generic_secret" "user" {
#   for_each = var.users

#   path = "auth/${vault_auth_backend.userpass.path}/users/${each.key}"

#   data_json = jsonencode({
#     password = each.value.password
#     policies = [vault_policy.users.name]
#   })

#   depends_on = [vault_auth_backend.userpass]
# }

module "users" {
  source = "./modules/users"
  users = var.users
  policy_names = [vault_policy.users.name]
  userpass_path = vault_auth_backend.userpass.path
}
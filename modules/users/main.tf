resource "vault_generic_secret" "user" {
  for_each = var.users

  path = "auth/${var.userpass_path}/users/${each.key}"

  data_json = jsonencode({
    password = each.value.password
    policies = var.policy_names
  })
}

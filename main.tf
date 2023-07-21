provider "vault" {
  # The Vault address and token will be read from the TF_VAR_vault_address and TF_VAR_vault_token environment variables
  address = var.vault_address
  token   = var.vault_token
}

resource "vault_policy" "example" {
  name   = "example-policy"
  policy = <<EOT
    path "secret/data/example" {
      capabilities = ["create", "read", "update", "delete"]
    }
  EOT
}

resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_generic_secret" "example_user" {
  path = "${vault_auth_backend.userpass.path}/users/example-user"

  data_json = jsonencode({
    password = var.user_password
    policies = [vault_policy.example.name]
  })
}

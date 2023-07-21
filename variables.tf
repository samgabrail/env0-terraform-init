variable "vault_address" {
  description = "The address of your Vault server"
  type = string
  default = "http://127.0.0.1:8200"
}

variable "user_password" {
  description = "The password for the new user"
}
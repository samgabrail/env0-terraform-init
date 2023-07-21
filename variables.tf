variable "vault_address" {
  description = "The address of your Vault server"
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "users" {
  description = "A map of user objects, where each object contains a password"
  type = map(object({
    password = string
  }))
}
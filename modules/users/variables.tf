variable "users" {
  description = "A map of user objects, where each object contains a password"
  type = map(object({
    password = string
  }))
}

variable "policy_names" {
  description = "A list of policy names to be attached to users"
  type = list(string)
}

variable "userpass_path" {
  description = "The path to the userpass auth method"
  type = string
}
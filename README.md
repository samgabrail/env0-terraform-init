# Overview
A demo for Terraform init

## Use Vault as an Example

We will use HashiCorp Vault in our example. So you'll need to start Vault like this:

```bash
vault server -dev -dev-root-token-id=root
```

## Run Terraform Init

Now open a new terminal tab and initialize terraform.

```bash
terraform init
```

Output:

```
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/vault...
- Installing hashicorp/vault v3.18.0...
- Installed hashicorp/vault v3.18.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Also, notice that a new `.terraform` folder was generated with the following content:

```
├── .terraform
│   └── providers
│       └── registry.terraform.io
│           └── hashicorp
│               └── vault
│                   └── 3.18.0
│                       └── linux_amd64
│                           └── terraform-provider-vault_v3.18.0_x5
```

Also notice a new file was created called `.terraform.lock.hcl`

Here is the content of this file:

```go
# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

provider "registry.terraform.io/hashicorp/vault" {
  version = "3.18.0"
  hashes = [
    "h1:e10+o2ABDgkhcg8pw+odmlrrtzl4PfAyevOjazAlRZ4=",
    "zh:0e898f977d2dbd0b2ffeb25520f6f3aaa0a078f654bf312dc12fefc327313204",
    "zh:11899fb3e6d2ce6215047cc37c4e1cbdc01334242103600d79009bcdda2cccd9",
    "zh:19c57f433f014f6275d1461dd190c50b1fbd2b1217718de6d2eb64e6a9bcea5c",
    "zh:4e2aa164ffd13080dc10d5de4256b684108126e1082c2613854e26a398831389",
    "zh:77abbf9d90d085677194305cf192f7890408881bbedc77e97c5146cef3e27a7c",
    "zh:78d5eefdd9e494defcb3c68d282b8f96630502cac21d1ea161f53cfe9bb483b3",
    "zh:790758438efe4389fdb0cabfb6f5118dad13869946665a72ba79a2f1102ff153",
    "zh:b9f3f1ba160a41545c4a8cb3a0d91fb37e194cfd6879ac7f358321851242ff78",
    "zh:bf19d8380e93a8a6ea8735cc015d4d04c6c588b233bb7cbb2bc3c277b7973f9a",
    "zh:de096c2afc87052e4848661ae5fc87528468399ae1a3ef242f1d6738504c79fc",
    "zh:eb4dce6a7bc10fa836cd379161bb5fad698d3288099e6ce0fa92ca3183acf242",
    "zh:f1c150dc13d6597ee08b83904fdd97a6702a106d3f524d60f048f2bd5c492f51",
  ]
}
```

## Run Terraform Plan

Let's first provide the vault token for Terraform to access Vault. Run the command below to set the VAULT_TOKEN environment variable.

```bash
export VAULT_TOKEN=root
```

Now let's run terraform plan:

```bash
terraform plan
```

## Run Terraform Apply

Run `terraform apply` to commit the changes.

```bash
terraform apply
```

## Login to Vault

You can now log into Vault with any of the 3 users' credentials. Let's use Sam's:

username: sam
password: sampass

Open a new terminal window and run the following:

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
vault login -method=userpass username=sam password=sampass
```

You can also use the Vault UI to sign in. Make sure to select the `username` Method, then enter the username and password.

## Refactor for Modules

Let's now refactor our code to create a module for the users. The point of this example is to show you the need to re-run the `terraform init` command to initialize the module.

In `main.tf`.

Comment the following:

```py
# resource "vault_generic_secret" "user" {
#   for_each = var.users

#   path = "auth/${vault_auth_backend.userpass.path}/users/${each.key}"

#   data_json = jsonencode({
#     password = each.value.password
#     policies = [vault_policy.users.name]
#   })

#   depends_on = [vault_auth_backend.userpass]
# }
```

and uncomment the following:

```go
module "users" {
  source = "./modules/users"
  users = var.users
  policy_names = [vault_policy.users.name]
}
```

Now try running `terraform plan` and notice the error message.

## Upgrade/Downgrade Provider or Module Version

Let's see how to override the `.terraform.lock.hcl` file to upgrade or downgrade a provider or module version.

In our example, we'll upgrade the Vault provider version from `3.17.0` to `3.18.0`.

In the `main.tf` file, change the version to `3.18.0` as shown below.

```go
terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.18.0"
    }
  }
}
```

Now try to run `terraform plan` and notice the error message indicating the need to use `terraform init -upgrade`.


If you try to run `terraform init` without the `-upgrade` option, you'll get a similar message.
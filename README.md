# Terraform Modules

1. First configure your `provider.tf` to add your [Enter Cloud Suite](https://www.entercloudsuite.com/en/) account credentials. [Example here](provisioner_template.tf)
2. Then with a single `main.tf` you can just adjust the `count` variable to a desirable value. [Example here](main_template.tf) 
3. Gererate a fresh SSH keypair with name `private.pem` and `private.pem.pub`. Assign permission code `600` to the private key.  
4. Run `terraform init` to allow terraform to obtain the modules
5. Run `terraform plan` and `terraform apply` to provision the infrastructure

## Note
This project is still in development, more documentation and modules will be added in the future. Stay tuned!
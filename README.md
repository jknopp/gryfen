# Gryfen
Testing things...
```bash
./init_terraform ./env/dev.tfvars.json true|false
terraform apply -var-file=./global.tfvars.json -var-file=./env/dev.tfvars.json
terraform destroy -var-file=./global.tfvars.json -var-file=./env/dev.tfvars.json
```

### Setup Azure Environment using Azure CLI & Terraform
Launch the container which contains the Azure CLI and Terraform, passing it our initialization scirpt:

```bash
docker container run -it --rm --mount type=bind,source=$PWD,target=/workspace zenika/terraform-azure-cli:latest ./init_azure
```

You can also run the container without the script to have full terminal access inside the container:

```bash
docker container run -it --rm --mount type=bind,source=$PWD,target=/workspace zenika/terraform-azure-cli:latest
```
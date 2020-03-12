# Gryfen
Testing things...

### Setup Azure Environment using Azure CLI & Terraform
Container credit to: https://github.com/Zenika/terraform-azure-cli

Launch the container which contains the Azure CLI and Terraform, passing it our initialization scirpt:

```bash
cd infrastructure/azure
docker container run -it --rm --mount type=bind,source=$PWD,target=/workspace zenika/terraform-azure-cli:latest ./init_local ../env/dev.tfvars.json true|false
cd mutable|immutable
terraform apply -var-file=./global.tfvars.json -var-file=../env/dev.tfvars.json
terraform destroy -var-file=./global.tfvars.json -var-file=../env/dev.tfvars.json
```

You can also run the container without the script to have full console access inside the container:

```bash
cd infrastructure/azure
docker container run -it --rm --mount type=bind,source=$PWD,target=/workspace zenika/terraform-azure-cli:latest
```
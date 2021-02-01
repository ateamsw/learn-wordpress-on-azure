# Setup Up the Azure Resources

## Terraform Init

```bash

# Use remote storage
terraform init --backend-config ./backend-secrets.tfvars

```

## Terraform Plan and Apply

```bash

# Run the plan to see the changes
terraform plan \
-var 'name_prefix=cdw' \
-var 'name_base=wordpress' \
-var 'name_suffix=20210131' \
-var 'location=westus2'

#--var-file=secrets.tfvars


# Apply the script with the specified variable values
terraform apply \
-var 'name_prefix=cdw' \
-var 'name_base=wordpress' \
-var 'name_suffix=20210131' \
-var 'location=westus2'

#--var-file=secrets.tfvars

```

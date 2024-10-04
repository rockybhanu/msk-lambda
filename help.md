The error you're encountering (`Reference to undeclared resource`) occurs because Terraform cannot find the resource you're referencing (`aws_msk_cluster.msk_cluster`) in the root module, likely because it's declared in a submodule or a different folder.

To resolve this, you need to ensure that your root module correctly references the resources declared in submodules or other folders.

### Steps to Fix:

1. **Ensure the MSK Resource is Declared in a Submodule**:
   - If your `aws_msk_cluster` resource is declared in a submodule (e.g., in another folder), you must reference it in the root module using the correct module path.

2. **Reference the Submodule**:
   - If your MSK cluster resource is in a different module, you should call the module in your root module and access the outputs from that submodule.

Here’s how you can adjust your configuration.

### Example Directory Structure:

```
terraform/
├── main.tf (root module)
├── modules/
│   └── msk/
│       ├── msk.tf (where your MSK cluster is declared)
```

### Step 1: Define the Module in Your Root `main.tf` (or other root file)

If the MSK cluster is in a module (e.g., `modules/msk`), you need to declare the module in your root module (`main.tf` or similar file):

```hcl
# Root module
module "msk_cluster" {
  source = "./modules/msk"
  # Pass any necessary variables to the module
}
```

### Step 2: Reference the MSK Cluster Output in the Root Module

Assuming the `aws_msk_cluster` resource is defined in the `modules/msk` submodule, you will need to reference it using `module.msk_cluster` in your outputs.

```hcl
# In your outputs.tf file
output "msk_bootstrap_brokers" {
  value = module.msk_cluster.msk_bootstrap_brokers
}
```

### Step 3: Declare Outputs in the Submodule (`modules/msk/msk.tf`)

Ensure that your submodule (where the `aws_msk_cluster` is defined) has an output for the `msk_bootstrap_brokers` value, like this:

```hcl
# modules/msk/msk.tf
output "msk_bootstrap_brokers" {
  value = aws_msk_cluster.msk_cluster.bootstrap_brokers_sasl_iam
}
```

### Recap:
1. **Define the module in the root**: Reference the submodule where your MSK cluster is declared.
2. **Use module references**: Access the output of the MSK cluster via `module.msk_cluster`.
3. **Ensure outputs are declared**: Make sure the MSK cluster module declares the appropriate outputs (e.g., `msk_bootstrap_brokers`).

By doing this, you’ll properly reference the MSK cluster resource declared in a different folder or submodule from your root module. Let me know if you need further clarification!
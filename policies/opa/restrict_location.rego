package terraform.policy

deny[msg] {
  resource := input.resource_changes[_]
  location := resource.change.after.location
  not location == "eastus"
  msg := sprintf("Resource %s deployed in disallowed location: %s (only eastus is permitted)", [resource.name, location])
}

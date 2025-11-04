package terraform.policy

required_tags = ["Owner", "Environment", "CostCenter"]

deny[msg] {
  resource := input.resource_changes[_]
  tags := resource.change.after.tags
  tag := required_tags[_]
  not tags[tag]
  msg := sprintf("Missing required tag '%s' on resource: %s", [tag, resource.name])
}

output "ping_results" {
  value = join(", ", null_resource.ping_test.*.triggers)
}

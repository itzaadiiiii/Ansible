output "instance_ids" { value = aws_instance.web[*].id }
output "instance_names" { value = [for i in aws_instance.web : i.tags.Name] }

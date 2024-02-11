output "public_ip_tf_instance" {
  value = aws_instance.tf_instance.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}
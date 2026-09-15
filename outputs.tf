output "postgres_endpoint" {
  description = "Endpoint privado do RDS Postgres (host:porta)."
  value       = aws_db_instance.postgres.endpoint
}

output "postgres_address" {
  description = "Endereco privado do RDS Postgres, sem porta."
  value       = aws_db_instance.postgres.address
}

output "postgres_port" {
  description = "Porta do Postgres."
  value       = aws_db_instance.postgres.port
}

output "db_security_group_id" {
  description = "ID do security group do Postgres."
  value       = aws_security_group.postgres.id
}

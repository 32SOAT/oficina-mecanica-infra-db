resource "aws_db_subnet_group" "postgres" {
  name       = "${local.name_prefix}-postgres"
  subnet_ids = data.aws_subnets.database.ids

  tags = {
    Name = "${local.name_prefix}-postgres"
  }
}

resource "aws_security_group" "postgres" {
  name        = "${local.name_prefix}-postgres"
  description = "Acesso ao Postgres apenas a partir do EKS"
  vpc_id      = data.aws_eks_cluster.this.vpc_config[0].vpc_id

  ingress {
    description     = "Postgres from EKS nodes"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-postgres"
  }
}

resource "aws_vpc_security_group_ingress_rule" "extra" {
  for_each = toset(var.extra_ingress_security_group_ids)

  security_group_id            = aws_security_group.postgres.id
  description                  = "Postgres from extra SG"
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = each.value
}

resource "aws_db_instance" "postgres" {
  identifier = "${local.name_prefix}-postgres"

  engine                 = "postgres"
  engine_version         = var.postgres_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  max_allocated_storage  = var.db_max_allocated_storage
  storage_type           = var.db_storage_type
  storage_encrypted      = true
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  port                   = var.db_port
  multi_az               = var.db_multi_az
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.postgres.id]

  backup_retention_period    = var.db_backup_retention_period
  deletion_protection        = var.db_deletion_protection
  skip_final_snapshot        = var.db_skip_final_snapshot
  final_snapshot_identifier  = var.db_skip_final_snapshot ? null : "${local.name_prefix}-postgres-final"
  apply_immediately          = var.db_apply_immediately
  auto_minor_version_upgrade = true

  tags = {
    Name = "${local.name_prefix}-postgres"
  }
}

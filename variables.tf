variable "aws_region" {
  type        = string
  description = "Regiao AWS onde a infraestrutura sera criada."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Nome base usado em tags e nomes de recursos."
  default     = "oficina-mecanica"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Use apenas letras minusculas, numeros e hifens em project_name."
  }
}

variable "environment" {
  type        = string
  description = "Ambiente da implantacao."
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.environment))
    error_message = "Use apenas letras minusculas, numeros e hifens em environment."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais aplicadas aos recursos AWS."
  default     = {}
}

variable "db_name" {
  type        = string
  description = "Nome do banco Postgres."
  default     = "oficina_mecanica"
}

variable "db_username" {
  type        = string
  description = "Usuario master do Postgres."
  default     = "oficina"
}

variable "db_password" {
  type        = string
  description = "Senha master do Postgres."
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "db_password precisa ter pelo menos 8 caracteres."
  }
}

variable "db_port" {
  type        = number
  description = "Porta do Postgres."
  default     = 5432
}

variable "db_instance_class" {
  type        = string
  description = "Classe da instancia RDS."
  default     = "db.t4g.micro"
}

variable "postgres_engine_version" {
  type        = string
  description = "Versao do engine Postgres. Deixe null para usar a versao padrao da AWS."
  default     = null
}

variable "db_storage_type" {
  type        = string
  description = "Tipo de armazenamento do RDS. Use gp2 no AWS Academy."
  default     = "gp3"

  validation {
    condition     = contains(["gp2", "gp3"], var.db_storage_type)
    error_message = "db_storage_type deve ser gp2 ou gp3."
  }
}

variable "db_allocated_storage" {
  type        = number
  description = "Armazenamento inicial do RDS, em GiB."
  default     = 20
}

variable "db_max_allocated_storage" {
  type        = number
  description = "Limite de autoscaling de armazenamento do RDS, em GiB."
  default     = 100
}

variable "db_backup_retention_period" {
  type        = number
  description = "Dias de retencao de backup do RDS."
  default     = 7
}

variable "db_multi_az" {
  type        = bool
  description = "Habilita Multi-AZ para o RDS."
  default     = false
}

variable "db_deletion_protection" {
  type        = bool
  description = "Protege o RDS contra delecao acidental."
  default     = false
}

variable "db_skip_final_snapshot" {
  type        = bool
  description = "Quando true, nao cria snapshot final ao destruir o RDS."
  default     = true
}

variable "db_apply_immediately" {
  type        = bool
  description = "Aplica alteracoes do RDS imediatamente."
  default     = true
}

variable "extra_ingress_security_group_ids" {
  type        = list(string)
  description = "Security groups adicionais autorizados a acessar o Postgres (ex.: SG da Lambda de autenticacao)."
  default     = []
}

data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

data "aws_subnets" "database" {
  filter {
    name   = "vpc-id"
    values = [data.aws_eks_cluster.this.vpc_config[0].vpc_id]
  }

  tags = {
    Tier = "database"
  }
}

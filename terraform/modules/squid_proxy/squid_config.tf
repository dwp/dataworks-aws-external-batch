data "template_file" "squid_conf" {
  template = file("${path.module}/templates/squid_conf.tpl")

  vars = {
    environment = var.environment

    cidr_block_external_batch_dev  = local.host_ranges.development.dataworks-aws-external-batch-vpc
    cidr_block_external_batch_qa   = local.host_ranges.qa.dataworks-aws-external-batch-vpc
    cidr_block_external_batch_int  = local.host_ranges.integration.dataworks-aws-external-batch-vpc
    cidr_block_external_batch_pre  = local.host_ranges.preprod.dataworks-aws-external-batch-vpc
    cidr_block_external_batch_prod = local.host_ranges.production.dataworks-aws-external-batch-vpc

  }
}

resource "aws_s3_bucket_object" "squid_conf" {
  bucket     = var.config_bucket.id
  key        = "${local.squid_config_s3_main_prefix}/squid.conf"
  content    = data.template_file.squid_conf.rendered
  kms_key_id = var.config_bucket.cmk_arn
  tags       = merge(var.common_tags, { Name : "${var.name_prefix}-squid-config" })
}

data "template_file" "whitelist" {
  template = file("${path.module}/templates/whitelist.tpl")
}

resource "aws_s3_bucket_object" "ecs_whitelists" {
  bucket     = var.config_bucket.id
  key        = "${local.squid_config_s3_main_prefix}/conf.d/whitelist"
  content    = data.template_file.whitelist.rendered
  kms_key_id = var.config_bucket.cmk_arn
  tags       = merge(var.common_tags, { Name : "${var.name_prefix}-ecs-whitelists" })
}

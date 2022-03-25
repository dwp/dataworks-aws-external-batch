resource "aws_kms_key" "emr_ebs" {
  description             = "dataworks-aws-external-batch-emr-ebs"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = merge({ "Name" = var.emr_cluster_name, "ProtectSensitiveData" = "True" }, var.common_tags)

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "emr_ebs" {
  name          = "alias/dataworks-aws-external-batch/emr-ebs"
  target_key_id = aws_kms_key.emr_ebs.id

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_key" "emr_s3" {
  description             = "dataworks-aws-external-batch-emr-s3"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = merge({ "Name" = var.emr_cluster_name, "ProtectSensitiveData" = "True" }, var.common_tags)

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "emr_s3" {
  name          = "alias/dataworks-aws-external-batch/emr-s3"
  target_key_id = aws_kms_key.emr_s3.id

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_key" "hive_data_s3" {
  description             = "dataworks-aws-external-batch-hive-data-s3"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = merge({ "Name" = "${var.emr_cluster_name}-hive-data", "ProtectSensitiveData" = "True" }, var.common_tags)

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "hive_data_s3" {
  name          = "alias/dataworks-aws-external-batch/hive-data-s3"
  target_key_id = aws_kms_key.hive_data_s3.id

  lifecycle {
    prevent_destroy = true
  }
}

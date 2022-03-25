resource "aws_lambda_function" "dataworks_aws_external_batch_emr_launcher" {
  filename      = "${var.dataworks_aws_external_batch_emr_launcher_zip["base_path"]}/emr-launcher-${var.dataworks_aws_external_batch_emr_launcher_zip["version"]}.zip"
  function_name = "dataworks_aws_external_batch_emr_launcher"
  role          = aws_iam_role.dataworks_aws_external_batch_emr_launcher_lambda_role.arn
  handler       = "emr_launcher.handler.handler"
  runtime       = "python3.7"
  source_code_hash = filebase64sha256(
    format(
      "%s/emr-launcher-%s.zip",
      var.dataworks_aws_external_batch_emr_launcher_zip["base_path"],
      var.dataworks_aws_external_batch_emr_launcher_zip["version"]
    )
  )
  publish = false
  timeout = 60

  environment {
    variables = {
      EMR_LAUNCHER_CONFIG_S3_BUCKET = var.config_bucket.id
      EMR_LAUNCHER_CONFIG_S3_FOLDER = "emr/batch-cluster"
      EMR_LAUNCHER_LOG_LEVEL        = "debug"
    }
  }
  tags = merge(var.common_tags, { Name : "${var.name_prefix}-emr-launch-lambda" })
}

resource "aws_iam_user_policy" "internal_max_looker_dashboard_beta_policy" {
  name = "internal_max_looker_dashboard_beta_policy"
  user = aws_iam_user.internal_max_looker_dashboard_beta.name


  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:List*",
                "s3:Put*"
            ],
            "Resource": [
                "arn:aws:s3:::hbo-max-looker-dashboard-beta/*",
                "arn:aws:s3:::hbo-max-looker-dashboard-beta"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::hbo-max-looker-dashboard-beta"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user" "internal_max_looker_dashboard_beta" {
  name = "internal_max_looker_dashboard_beta@hbo.com"
  path = "/"

  tags = {
      "KEYPOC" = "Harsh.Sheth@warnermedia.com"
      "TEAMPOC" = "maxdatengtea@warnermedia.com"
      "KeyUsage" = "External"
      "Name" = "${var.environment}-${var.project}-${var.service}"
      "environment" = "${var.environment}"
      "project" = "MAX"
      "service" = "${var.service}"
      "managed_by" = "DAP-ADMIN-TERRAFORM"
  }
}
resource "aws_iam_access_key" "internal_max_looker_dashboard_beta_key" {
  user = "${aws_iam_user.internal_max_looker_dashboard_beta.name}"
}


resource "aws_kms_ciphertext" "internal_max_looker_dashboard_beta_encrypt_secret_key" {
  key_id = "alias/internal_cloudops_encryption"
  plaintext = "${aws_iam_access_key.internal_max_looker_dashboard_beta_key.secret}"
  }

resource "aws_dynamodb_table_item" "internal_max_looker_dashboard_beta_serviceaccount" {
  table_name = "serviceaccount"
  hash_key   = "name"
  item = <<ITEM
{
  "name": {"S": "${aws_iam_user.internal_max_looker_dashboard_beta.name}"},
  "accessid": {"S": "${aws_iam_access_key.internal_max_looker_dashboard_beta_key.id}"},
  "accesskey": {"S": "${aws_kms_ciphertext.internal_max_looker_dashboard_beta_encrypt_secret_key.ciphertext_blob}"}
}
ITEM
}

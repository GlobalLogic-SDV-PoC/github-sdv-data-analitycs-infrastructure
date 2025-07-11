provider "aws" {
  region = "eu-west-1"
}

data "aws_s3_bucket" "edge_to_cloud" {
  bucket = "edge-to-cloud-bucket"
}

resource "aws_iam_role" "github_actions_artifact_uploader" {
  name = "GitHubActionsArtifactUploaderRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" = "repo:GlobalLogic-SDV-PoC/github-sdv-poc-msp-ipc:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "github_actions_s3_write" {
  name = "AllowS3WriteForArtifacts"
  role = aws_iam_role.github_actions_artifact_uploader.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          data.aws_s3_bucket.edge_to_cloud.arn,
          "${data.aws_s3_bucket.edge_to_cloud.arn}/build-artifacts/*"
        ]
      }
    ]
  })
}


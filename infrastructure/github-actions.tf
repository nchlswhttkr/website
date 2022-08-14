resource "github_actions_secret" "aws_access_key_id" {
  repository      = "website"
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = aws_iam_access_key.preview_credentials.id
}

resource "github_actions_secret" "aws_access_key_secret" {
  repository      = "website"
  secret_name     = "AWS_ACCESS_KEY_SECRET"
  plaintext_value = aws_iam_access_key.preview_credentials.secret
}

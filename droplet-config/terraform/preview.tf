resource "aws_s3_bucket" "preview" {
  bucket = "preview.nicholas.cloud"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.preview.bucket
}

data "aws_iam_policy_document" "public_bucket_access" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = ["${aws_s3_bucket.preview.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "preview_bucket_policy" {
  bucket = aws_s3_bucket.preview.bucket
  policy = data.aws_iam_policy_document.public_bucket_access.json
  depends_on = [
    aws_s3_bucket_public_access_block.public_access_block
  ]
}

resource "aws_iam_user" "preview" {
  name = "PreviewManager"
}

resource "aws_iam_access_key" "preview_credentials" {
  user = aws_iam_user.preview.name
}

data "aws_iam_policy_document" "manage_preview_objects" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.preview.arn,
      "${aws_s3_bucket.preview.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "manage_preview_objects" {
  name   = "ManagePreviewObjects"
  policy = data.aws_iam_policy_document.manage_preview_objects.json

}

resource "aws_iam_user_policy_attachment" "manage_preview_objects" {
  user       = aws_iam_user.preview.name
  policy_arn = aws_iam_policy.manage_preview_objects.arn
}
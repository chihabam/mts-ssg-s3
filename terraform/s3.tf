module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"
  bucket  = var.bucket-name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "denyUnencryptedObjectUploads",
            "Effect" : "Deny",
            "Principal" : "*",
            "Action" : "s3:PutObject",
            "Resource" : "arn:aws:s3:::${var.bucket-name}/*",
            "Condition" : {
              "Null" : {
                "s3:x-amz-server-side-encryption" : "true"
              }
            }
          },
          {
            "Sid" : "PublicReadGetObject",
            "Effect" : "Allow",
            "Principal" : "*",
            "Action" : "s3:GetObject",
            "Resource" : "arn:aws:s3:::${var.bucket-name}/*"
          }
        ]
      }
    ]
  })
  attach_public_policy    = true
  restrict_public_buckets = false
  object_ownership        = "BucketOwnerPreferred"

  force_destroy = true
}

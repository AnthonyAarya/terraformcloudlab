resource "aws_s3_bucket" "mybucket" {
  bucket = join("-", [var.region, var.az[0], var.buck])
}

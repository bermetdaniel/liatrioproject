### Remote Backend ###
output "bucket_name" {
  value = aws_s3_bucket.tf-remote-state.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.dynamodb-terraform-state-lock.name
}
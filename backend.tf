terraform {
  backend "s3" {
    bucket         = "k-surabhi-tfbackend-bucket"
    key            = "terraform.tfstate"
    region         =  "eu-west-1"
    # dynamodb_table = var.dynamodb_table
  }
}
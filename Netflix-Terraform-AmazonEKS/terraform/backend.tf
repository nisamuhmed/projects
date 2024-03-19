terraform {
  backend "s3" {
    bucket = "eks-buckett"  
    key    = "EKS/terraform.tfstate"
    region = "us-west-1"
  }
}

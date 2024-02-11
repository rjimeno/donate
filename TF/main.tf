
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.35"
    }
  }

}

provider "aws" {
  region = var.region # AMIs are region-specific; may need adjusting.
}

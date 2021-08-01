provider "aws" {
  region = "eu-central-1"
  alias  = "central"
}

provider "aws" {
  region = "eu-north-1"
  alias  = "north"
}

module "ec2-instance-central" {
  source = "github.com/viv-garot/sg-aws"
  providers = {
    aws = aws.central
  }
}

module "ec2-instance-north" {
  source = "github.com/viv-garot/sg-aws"
  providers = {
    aws = aws.north
  }
}

output "central-sg-id" {
  value = module.ec2-instance-central.sg_id
}

output "north-sg-id" {
  value = module.ec2-instance-north.sg_id
 }

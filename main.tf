provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Owner   = var.tag_owner
      Purpose = var.tag_purpose
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "rst-eks-project-state-file"
    region         = "ap-south-1"
    key            = "RST/EKS/terraform.tfstate"
    dynamodb_table = "rst-eks-state-lock"
    encrypt        = true
  }
}

## VPC Creation
module "vpc" {
  source   = "git::https://github.com/tejasacharekar1/Terraform_modules.git//vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_tag_name
}

## Subnet Creation
module "Subnets" {
  source        = "git::https://github.com/tejasacharekar1/Terraform_modules.git//Subnets"
  vpc_id        = module.vpc.vpc_id
  project       = var.project
  public_sub_1  = var.pub1_subnet_cidr
  public_sub_2  = var.pub2_subnet_cidr
  private_sub_1 = var.pvt1_subnet_cidr
  private_sub_2 = var.pvt2_subnet_cidr
  depends_on    = [module.vpc]
}

## IGW Creation and route table association
module "igw" {
  source     = "git::https://github.com/tejasacharekar1/Terraform_modules.git//igw"
  vpc_id     = module.vpc.vpc_id
  project    = var.project
  depends_on = [module.vpc]
  pub_sub1   = module.Subnets.pub_sub_id1
  pub_sub2   = module.Subnets.pub_sub_id2
}

## NAT GW Creation and route table association
module "nat-gw" {
  source         = "git::https://github.com/tejasacharekar1/Terraform_modules.git//nat-gw"
  project        = var.project
  vpc_id         = module.vpc.vpc_id
  pub_subnet_id  = module.Subnets.pub_sub_id1
  pvt_subnet_id1 = module.Subnets.pvt_sub_id1
  pvt_subnet_id2 = module.Subnets.pvt_sub_id2
}

## Module for Security Group
module "infra-sg" {
  source  = "git::https://github.com/tejasacharekar1/Terraform_modules.git//security-gp"
  vpc_id  = module.vpc.vpc_id
  project = var.project
}

## EKS Cluster Creation
module "eks_creation" {
  source              = "git::https://github.com/tejasacharekar1/Terraform_modules.git//eks"
  project             = var.project
  vpc_id              = module.vpc.vpc_id
  eks_version         = var.eks_version
  pub_sub1            = var.pub1_subnet_cidr
  pub_sub2            = var.pub2_subnet_cidr
  pvt_sub1            = var.pvt1_subnet_cidr
  pvt_sub2            = var.pvt2_subnet_cidr
  desired_size_pub_ng = var.desired_size_pub_ng
  max_size_pub_ng     = var.max_size_pub_ng
  min_size_pub_ng     = var.min_size_pub_ng
  desired_size_pvt_ng = var.desired_size_pvt_ng
  max_size_pvt_ng     = var.max_size_pvt_ng
  min_size_pvt_ng     = var.min_size_pvt_ng
  ami_type            = var.ami_type
  capacity            = var.capacity
  disk_size           = var.disk_size
  instance_types      = var.instance

  pub_sub1_id = module.Subnets.pub_sub_id1
  pub_sub2_id = module.Subnets.pub_sub_id2
  pvt_sub1_id = module.Subnets.pvt_sub_id1
  pvt_sub2_id = module.Subnets.pvt_sub_id2
}
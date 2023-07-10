## Project
project     = "RST_EKS_Project"
region      = "ap-south-1"
tag_owner   = "Tejas"
tag_purpose = "EKS_Infra"

## Variabels for VPC
vpc_cidr     = "10.20.0.0/16"
vpc_tag_name = "EKS VPC"

## Values for Subnets
pub1_subnet_cidr   = "10.20.0.0/18"
pub2_subnet_cidr   = "10.20.64.0/18"
pvt1_subnet_cidr   = "10.20.128.0/18"
pvt2_subnet_cidr   = "10.20.192.0/18"
availability_zone1 = "ap-south-1a"
availability_zone2 = "ap-south-1b"

## EKS Required Values
eks_version         = "1.27"
desired_size_pub_ng = 1
max_size_pub_ng     = 5
min_size_pub_ng     = 1
desired_size_pvt_ng = 1
max_size_pvt_ng     = 3
min_size_pvt_ng     = 1
ami_type            = "AL2_x86_64"
capacity            = "SPOT"
disk_size           = 20
instance            = "t3a.medium"
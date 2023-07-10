pipeline {
    agent any
    environment
	{
	awscredential = credentials("$account")
	}
    parameters {
        booleanParam(name: 'ClusterPlan', description: 'Planning EKS Cluster')
        booleanParam(name: 'ClusterCreate', description: 'Creating EKS Cluster')
        booleanParam(name: 'ClusterDestroy', description: 'Destroy Cluster')
    }
    stages {
        stage('Initiating Terraform configuration')
        {
            steps {
                bat('terraform init')
                }
            }
        stage('Planning EKS Cluster') {
            when
		    {
		        expression{"${params.ClusterPlan}"=="true"}
		    }
            steps {
                bat('terraform plan --var-file value.tfvars -no-color')
            }
        }
        stage('Creating EKS Cluster') {
            when
		    {
		        expression{"${params.ClusterCreate}"=="true"}
		    }
            steps {
                bat('terraform apply --var-file value.tfvars --auto-approve -no-color')
            }
        }
        stage('Destroy Cluster') {
            when
            {
                expression{"${params.ClusterDestroy}"=="true"}
            }
            steps {
                bat ('terraform destroy --var-file value.tfvars --auto-approve -no-color')
            }
        }
    }
}   
# AWS-terraform-GitHub

Build the IaC using terraform to leverage s3 backend and create a EC2 resource and Github repository.

The terraform state file will be stored s3 bucket.

> Note: we could use the dynamo db for storing the terraform lock state however we are not using it as it is out of the scope for this project


## Architecture diagram
![alt text](/images/architecture-Page-1.png)

## Prerequisite
### AWS Account:

<ol>
<li>Set up your AWS console</li>
<li>Create an environment variable in windows. </li> 
</ol>

Use the link for a guide: [environment setup for windows](https://kb.wisc.edu/cae/page.php?id=24500)


### Install Terraform:
<ol>
<li>Download and install Terraform from the official website.</li>
<li>Add the Terraform binary to your system's PATH.</li>
</ol>

Use the link for a guide: [ Terraform ](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Steps to use terraform to create AWS resources

<ol> 
<li> Create a repository in github (AWS-terraform-GitHub) and clone it into your local host. </li>

```
git clone https://github.com/k-surabhi/AWS-terraform-GitHub
```

<li> Create the terraform file, which looks as follows: </li>

![alt text](/images/tree.png)

</ol>

> main.tf     #configure the aws cloud provider, s3 and ec2 resource

```
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "devops" {
  ami           = "ami-0766b4b472db7e3b9"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
```

> Create rest of the supporting files as shown in the screenshot
backend.tf          # Configure terraform remote backend in s3
variables.tf        # Define the variable used
terraform.tfvars    # Supply the variables



## Steps to execute the terraform code


```
Terraform init #Download the required provider and configure the backend
```
![alt text](/images/init.png)

```
Terraform plan #What resource is is going to create
```
![alt text](/images/image.png)

```
Terraform apply #create the resources on the aws
```
![alt text](/images/apply1.png)


Now, you can log into the console and see the resources create as shown in the screen shot below

> EC2 Instance

![alt text](/images/ec2.png)

> S3 bucket

![alt text](/images/s3screenshot.png)


if you no longer require the resource you can remove the resources using terraform, use the command below :

This will destroy all the resources created

```
terraform destroy 
```

This will destroy based on the target

```
Terraform destroy --target aws_instance.devops
```
![alt text](/images/destroy1.png)
![alt text](/images/destroy.png)

> NOTE: S3 bucket is not destroyed as it is used to store the state file and is not empty, the s3 bucket first must be empty to be destroyed using terraform, hence we are using the target based destroy



## Github repository creation

### Prerequisite
To create the github repository you would require a github PAT token, which you can create by logging into your account

> Github -> Settings -> Developer settings

![alt text](/images/token.png)

> NOTE: Make sure to provide the access to create github repository permission while creating the token 
![alt text](/images/permission.png)

Since github token is secret so we can not write the github token in terraform code, therefore we will be using the environment variable

```
$env:TF_VAR_gh_token="github_pat_xxxxxxxxxxxxxxxxxxxxx"
```

Also make the following changes in your code


github.tf 
```
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.gh_token # Accept the token as github variable
}

resource "github_repository" "surabhitest1" {
  name        = "projectDevops789123"
  description = "My first test"

  visibility = "public"


}

```

Variables.tf
```
variable "gh_token" {
  description = "Used for pat token"
  type        = string
}
```

Once the prerequisite and code block is completed .Execute the following command.
```
terraform init   # download github provider
terraform plan
terraform apply
```



on apply the terraform will look for an env variable TF_VAR_gh_token and will create a git hub repository as shown in the screenshot below:


![alt text](/images/githubrepo.png)






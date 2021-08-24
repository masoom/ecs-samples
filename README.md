#### README

Sample Terraform Module & Plan for ECS Fargate
Reference https://github.com/terraform-aws-modules/terraform-aws-ecs

Terraform Module & Plan: 
Refer /Terraform/tf-module and /Terraform/tf-plan

#### Terraform 
Usage : 

``` terraform init
    terraform plan
    terraform apply
```    

To Destroy Resources:
```
    terraform destroy
```    


### Cloudformation: 
Refer Cloudformation template in /Cloudformation


#### API:

Check src/app/py

Send a Post Request to endpoint `/api/copyright`

Example JSON Body:

`{
     "input": "Consulting offers a range of mult-cloud projects with clients in banking using Google Cloud."
 }
`

Response:


`{
     "Consulting offers a range of mult-cloud projects with clients in banking using Google© Cloud."
 }
`



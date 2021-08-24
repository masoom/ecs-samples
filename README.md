#### README

Python Flask based API Deployed on AWS ECS Fargate and provisioned using Terraform or Cloudformation.


#### Docker Image 
Docker Image URI : `public.ecr.aws/i5k1d4j1/deloitte-copyright-api:1.0`

Pull Docker Image to test 

`docker pull public.ecr.aws/i5k1d4j1/deloitte-copyright-api:1.0`

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



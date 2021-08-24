This Terraform module can be used to install deloitte copyright api to an AWS Account


As a user of the module, you can pass values to the variables defined in the TF Module, For Example

- DOMAIN 
``` domain_name     = "" ```

- CERTIFICATE_ARN
```  certificate_arn = "arn:aws:acm:eu-west-1:252159305430:certificate/e7a45135-cd63-4ac4-9e6f-2bf8adb32d81" ``` 

- Docker Image
```    image           = "public.ecr.aws/i5k1d4j1/deloitte-copyright-api" ```  

- Docker Image Tags
```     tag             = "1.0" ``` 

- Bucket name for ELB Access Logs
```     bucket_name     =  "copyright-logs-bucket" ```


### Usage : 

``` terraform init
    terraform plan
    terraform apply
```    

### To Destroy Resources:
```
    terraform destroy
```    


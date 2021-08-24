include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  source = local.common.locals.statuspage.source
}

terraform {
  source = local.source
}

inputs = {
  zone            = "api.deloitte.org"
  vpc_id          = "vpc-0b0a2d3c5xxxxx"
  private_subnets = ["subnet-02354541xxxx", "subnet-0582a441axxx", "subnet-01b78539xxx"]
  domain_name     = "api.deloitte.org"
  certificate_arn = "arn:aws:acm:eu-west-1:xxxxxx:certificate/e7a45135-cd63-4ac4-9e6f-2bf8adb32d81"
  name            = "copyright-api"
  sns_topic_arn   = "arn:aws:sns:eu-west-1:xxxxxx:deloitte-account-events"
  bucket_name     = "copyright-api-prd-elb-logs"
  web_acl_id      = "7b61cb51-ad73-4435-aed9-xxxxx"
}

# S3 shared bucket for WOS

Terraform infrastructrue to deploy a shared bucket with the following characteristics:

 * Encryption enforced
 * For snapshot key, used only for non-prod environment, will be cleaned up every 2 weeks
 * Condition to added string in the request to write objects
 * wos-dev and wos prod will have access to this bucket
 

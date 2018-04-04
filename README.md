# S3 shared bucket for WOS

Terraform infrastructrue to deploy a shared bucket with the following characteristics:

 * Encryption enforced: sse-AES256
 * For snapshot key, used only for non-prod environment, will be cleaned up every 14 days
 * Acl conditional: bucket-owner-full-control
 * AWS accounts wos-dev and wos-prod will have access to this bucket.
 
 ## Bucket

#### In wos-dev account, us-east-1 region:
```
s3://clarivate.wos.dev.us-east-1.build-tools
```

#### Prefix with expiration time:
```
/artifacts/snapshots/
```

#### Upload files:
```
aws s3 cp ./<file_name> s3://clarivate.wos.dev.us-east-1.build-tools/artifacts/snapshots/<file_name> --profile <your_profile> --acl bucket-owner-full-control
```
the file will be automatically encrypted upon upload.

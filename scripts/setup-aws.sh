#!/bin/bash

set -e

echo "🚀 Setting up AWS Infrastructure for E-Commerce Platform"

# Create S3 bucket for Terraform state
S3_BUCKET_NAME="ecommerce-terraform-state-$(date +%s)"
aws s3api create-bucket --bucket $S3_BUCKET_NAME --region us-east-1
aws s3api put-bucket-versioning --bucket $S3_BUCKET_NAME --versioning-configuration Status=Enabled
echo "✅ S3 bucket $S3_BUCKET_NAME created and versioning enabled."

# Create DynamoDB table for Terraform state locking
DYNAMODB_TABLE_NAME="ecommerce-terraform-locks"
aws dynamodb create-table \
    --table-name $DYNAMODB_TABLE_NAME \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
echo "✅ DynamoDB table $DYNAMODB_TABLE_NAME created."

# Initialize Terraform
terraform init \
    -backend-config="bucket=$S3_BUCKET_NAME" \
    -backend-config="dynamodb_table=$DYNAMODB_TABLE_NAME" \
    -backend-config="region=us-east-1"
echo "✅ Terraform initialized with S3 bucket and DynamoDB table."

echo "🎉 AWS Infrastructure setup complete!"

#!/bin/bash

set -e

ENVIRONMENT=${1:-"production"}
AWS_REGION=${AWS_REGION:-"us-east-1"}
PROJECT_NAME="ecommerce-devops"

echo "🚀 Deploying to ${ENVIRONMENT}..."

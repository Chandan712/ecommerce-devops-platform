#!/bin/bash

echo "🚀 Setting up GitHub repository..."

# Initialize git if not already done
if [ ! -d .git ]; then
    git init
fi

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Complete e-commerce DevOps platform

- Microservices architecture (User, Product, Order services)
- React frontend with Material-UI
- API Gateway with rate limiting
- Complete AWS infrastructure with Terraform
- Kubernetes manifests with Kustomize
- CI/CD with GitHub Actions
- Monitoring with Prometheus & Grafana
- Production-ready Docker containers
- Comprehensive documentation"

echo "✅ Git repository initialized"
echo ""
echo "📋 Next steps:"
echo "1. Create a new repository on GitHub"
echo "2. Run: git remote add origin https://github.com/YOUR_USERNAME/ecommerce-devops-platform.git"
echo "3. Run: git push -u origin main"
echo ""
echo "🎉 Your DevOps portfolio project is ready!"

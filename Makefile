.PHONY: help install build up down logs test deploy clean

# Variables
PROJECT_NAME := ecommerce-devops
AWS_REGION := us-east-1
ENVIRONMENT := production

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install dependencies for all services
	@echo "📦 Installing dependencies..."
	@cd services/user-service && npm install
	@cd services/product-service && npm install
	@cd services/order-service && npm install
	@cd services/api-gateway && npm install
	@cd frontend && npm install
	@echo "✅ Dependencies installed"

build: ## Build all Docker images
	@echo "🔨 Building Docker images..."
	@docker-compose build
	@echo "✅ Build complete"

up: ## Start all services locally
	@echo "🚀 Starting services..."
	@docker-compose up -d
	@echo "✅ Services started"
	@echo "Frontend: http://localhost:8080"
	@echo "API Gateway: http://localhost:3000"

down: ## Stop all services
	@echo "🛑 Stopping services..."
	@docker-compose down
	@echo "✅ Services stopped"

logs: ## View logs
	@docker-compose logs -f

test: ## Run tests
	@echo "🧪 Running tests..."
	@cd services/user-service && npm test
	@cd services/product-service && npm test
	@cd services/order-service && npm test
	@echo "✅ Tests passed"

# AWS Deployment
setup-aws: ## Setup AWS infrastructure with Terraform
	@echo "☁️ Setting up AWS infrastructure..."
	@cd infrastructure/terraform && \
		terraform init && \
		terraform plan -out=tfplan && \
		terraform apply tfplan
	@echo "✅ AWS infrastructure ready"

deploy-production: ## Deploy to production
	@echo "🚀 Deploying to production..."
	@./scripts/deploy.sh production
	@echo "✅ Deployment complete"

deploy-staging: ## Deploy to staging
	@echo "🚀 Deploying to staging..."
	@./scripts/deploy.sh staging
	@echo "✅ Deployment complete"

# Database
init-db: ## Initialize database
	@echo "🗄️ Initializing database..."
	@./scripts/init-db.sh
	@echo "✅ Database initialized"

# Monitoring
port-forward-grafana: ## Port forward to Grafana
	@kubectl port-forward -n monitoring svc/grafana 3000:80

port-forward-kibana: ## Port forward to Kibana
	@kubectl port-forward -n logging svc/kibana 5601:5601

# Cleanup
clean: ## Clean up local environment
	@echo "🧹 Cleaning up..."
	@docker-compose down -v
	@find . -name "node_modules" -type d -prune -exec rm -rf {} +
	@find . -name "dist" -type d -prune -exec rm -rf {} +
	@echo "✅ Cleanup complete"

destroy-aws: ## Destroy AWS infrastructure
	@echo "⚠️  This will destroy all AWS resources!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		cd infrastructure/terraform && terraform destroy; \
	fi
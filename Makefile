# Make network
.PHONY: mk_network
mk_network:
	docker network create kitemiru_next_network

# Remove network
.PHONY: rm_network
rm_network:
	docker network rm kitemiru_next_network

# Development
.PHONY: dev
dev:
	docker-compose -f docker-compose.dev.yml build
	docker-compose -f docker-compose.dev.yml up

# Production
.PHONY: prod
prod:
	docker-compose -f docker-compose.prod.yml build
	docker-compose -f docker-compose.prod.yml up -d

# Production (without mulitstage)
.PHONY: prod-without-multi-stage
prod-without-mulit-stage:
	docker-compose -f docker-compose.prod-without-multistage.yml build
	docker-compose -f docker-compose.prod-without-multistage.yml up -d

# Stop all running containers
.PHONY: kill
kill:
	docker kill $(docker ps -aq) && docker rm $(docker ps -aq)

# Free space
.PHONY: free
free:
	docker system prune -af --volumes
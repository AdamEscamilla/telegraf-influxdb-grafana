# Usage:
#   [NODE_ENV=test] make up   
NODE_ENV?=development 

release: down up down

# builds the docker images and then starts the containers telegraf, influxdb and grafana
up: 
	docker-compose up --build -d

# remove previous images and containers
down:
	docker-compose down

.PHONY: release down up

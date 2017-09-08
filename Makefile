# Usage:
#   [NODE_ENV=test] make up   
NODE_ENV?=development 

release: down up down

# builds the docker images and then starts the containers telegraf, influxdb and grafana
up: 
	docker-compose up --build -d
	docker exec -it grafana sh -c "mkdir -p /var/lib/grafana/dashboards"
	docker cp ./grafana/Docker\ Monitoring.json grafana:/var/lib/grafana/dashboards
	docker cp ./grafana/install.sh grafana:/
	until [ `curl -s -I -o /dev/null -w '%{http_code}' http://localhost:3000` == 302 ]; do sleep 1.5; done
	docker exec -it grafana sh /install.sh

# remove previous images and containers
down:
	docker-compose down

.PHONY: release down up

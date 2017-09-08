#!/bin/sh

set -e

if [ "${1:0:1}" = '-' ]; then
    set -- influxd "$@"
fi

exec

"$@" &

sleep 5

INFLUXDB_HOST="localhost"
INFLUXDB_API_PORT="8086"
INFLUXDB_ADMIN_USER=${INFLUXDB_ADMIN_USER:-grafana}
INFLUXDB_ADMIN_PASS=${INFLUXDB_ADMIN_PASS:-grafana}
INFLUXDB_DATABASE=${INFLUXDB_DATABASE:-telegraf}

USER_EXISTS=`influx -host=${INFLUXDB_HOST} -port=${INFLUXDB_API_PORT} -execute="SHOW USERS" | awk '{print $1}' | grep "${INFLUXDB_ADMIN_USER}" | wc -l`

if [ -n ${USER_EXISTS} ]; then
  influx -host=${INFLUXDB_HOST} -port=${INFLUXDB_API_PORT} -execute="CREATE USER ${INFLUXDB_ADMIN_USER} WITH PASSWORD '${INFLUXDB_ADMIN_PASS}' WITH ALL PRIVILEGES"
  influx -host=${INFLUXDB_HOST} -port=${INFLUXDB_API_PORT} -username=${INFLUXDB_ADMIN_USER} -password="${INFLUXDB_ADMIN_PASS}" -execute="create database ${INFLUXDB_DATABASE}"
  influx -host=${INFLUXDB_HOST} -port=${INFLUXDB_API_PORT} -username=${INFLUXDB_ADMIN_USER} -password="${INFLUXDB_ADMIN_PASS}" -execute="grant all PRIVILEGES on ${INFLUXDB_DATABASE} to ${INFLUXDB_ADMIN_USER}"
fi

wait

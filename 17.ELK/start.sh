#!/bin/bash

chown root:root filebeat.yml
chmod 200 filebeat.yml

chown root:root metricbeat.yml
chmod 200 metricbeat.yml

docker compose up

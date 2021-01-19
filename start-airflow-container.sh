#!/usr/bin/env bash
docker run -d -p 8080:8080 -v /home/ubuntu/docker-airflow/live_parser/dags:/usr/local/airflow/dags -v /home/ubuntu/docker-airflow/live_parser:/usr/local/airflow/live_parser -v /home/ubuntu/docker-airflow/requirements.txt:/requirements.txt airflow webserver scheduler
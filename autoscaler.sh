#!/bin/bash

SERVICE=nginx-stack_nginx
CPU_SCALE_UP=70
CPU_SCALE_DOWN=30
MIN_REPLICAS=1
MAX_REPLICAS=10

while true; do
  CPU=$(docker stats --no-stream --format "{{.CPUPerc}}" $(docker ps --filter "name=$SERVICE" -q) | sed 's/%//g' | awk '{ sum += $1 } END { if (NR > 0) print sum / NR; else print 0 }')
  REPLICAS=$(docker service ls --filter name=$SERVICE --format "{{.Replicas}}" | cut -d/ -f1)

  echo "CPU: $CPU%, Replicas: $REPLICAS"
  
  if (( $(echo "$CPU > $CPU_SCALE_UP" | bc -l) )); then
    NEW_REPLICAS=$((REPLICAS + 1))
    if [ "$NEW_REPLICAS" -le "$MAX_REPLICAS" ]; then
      echo "High CPU detected! Scaling up to $NEW_REPLICAS replicas..."
      docker service scale $SERVICE=$NEW_REPLICAS
    else
      echo "Already at max replicas ($MAX_REPLICAS). No scaling up."
    fi

  elif (( $(echo "$CPU < $CPU_SCALE_DOWN" | bc -l) )); then
    NEW_REPLICAS=$((REPLICAS - 1))
    if [ "$NEW_REPLICAS" -ge "$MIN_REPLICAS" ]; then
      echo "Low CPU detected! Scaling down to $NEW_REPLICAS replicas..."
      docker service scale $SERVICE=$NEW_REPLICAS
    else
      echo "Already at min replicas ($MIN_REPLICAS). No scaling down."
    fi
  else
    echo "CPU usage is normal. No scaling action."
  fi

  sleep 30
done

#!/bin/bash
set -e

    python /home/venv/lib/python3.9/site-packages/ts/model_service_worker.py --sock-type unix --sock-name /home/model-server/tmp/.ts.sock.9000 --metrics-config /home/venv/lib/python3.9/site-packages/ts/configs/metrics.yaml --model-path /mnt/models &
    eval "$@" &
    python /home/model-server/kserve_wrapper/__main__.py
    
# prevent docker exit
tail -f /dev/null

#!/bin/bash
set -e

    # Path to the socket file
    SOCKET_FILE=/home/model-server/tmp/.ts.sock.9000
    python /home/venv/lib/python3.9/site-packages/ts/model_service_worker.py --sock-type unix --sock-name $SOCKET_FILE --metrics-config /home/venv/lib/python3.9/site-packages/ts/configs/metrics.yaml --model-path /mnt/models &
    
    # Get the current date and time in the desired format without milliseconds
    current_time=$(date "+%Y-%m-%d %H:%M:%S")
    # Use date and awk to get milliseconds
    milliseconds=$(date "+%N") # %N gives nanoseconds
    milliseconds=$(echo $milliseconds | awk '{print substr($0, 1, 3)}') # Get the first 3 digits for milliseconds
    # Combine the two parts
    formatted_time="${current_time}.${milliseconds}"
    echo "$formatted_time Container starts - first log"

    # Wait for the socket file to exist
    echo "Waiting for socket file at $SOCKET_FILE"
    while [ ! -S "$SOCKET_FILE" ]; do
        sleep 0.1
    done
    echo "Socket file found at $SOCKET_FILE"
    eval "$@" &

    # Function to execute upon receiving the SIGTERM signal
    graceful_shutdown() {
        echo "SIGTERM signal received, starting graceful shutdown..."
        pkill python
        pkill java
        pkill tail
        exit 0
    }
    # Trap SIGTERM signal and link it to the graceful_shutdown function
    trap 'graceful_shutdown' SIGTERM

    python /home/model-server/kserve_wrapper/__main__.py
    
# prevent docker exit
tail -f /dev/null

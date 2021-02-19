#!/usr/bin/env bash

# adapted from https://www.codegrepper.com/code-examples/typescript/how+to+get+docker+stats+using+shell+script

# for logging purposes
echo "--- --- ---"
date
docker container ls -a
docker stats --no-stream

currenttime=$(date +%H:%M)


# check if container is down, else check memory usage
if [ ! "$(docker ps -q -f name=agitated_raman)" ]
then 
    echo "Container was down. Restarting. "
    docker restart agitated_raman

# time based restart once a day
# elif [[ "$currenttime" > "19:45" ]] && [[ "$currenttime" < "20:00" ]]
# then 
    # echo "Daily Restart. "
    # docker restart agitated_raman

# script to restart container if memory usage is too high
else
    IFS=;
    DOCKER_STATS_CMD=`docker stats --no-stream --format "table {{.MemPerc}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.Name}}"`
    SUM_RAM=`echo $DOCKER_STATS_CMD | tail -n +2 | sed "s/%//g" | awk '{s+=$1} END {print s}'`

    SUM_RAM_INT=${SUM_RAM%.*}

    RAM_THRESHOLD=70

    if [ "${SUM_RAM_INT}" -ge "${RAM_THRESHOLD}" ]
        then echo "Memory usage ${SUM_RAM_INT}% is larger than the threshold of ${RAM_THRESHOLD}%"
            echo "restarting Container"
            docker restart agitated_raman
        else echo "Memory usage ${SUM_RAM_INT}% is less than the threshold of ${RAM_THRESHOLD}%"
            echo "skipping restart"
    fi
fi
#!/bin/bash

CUR=$(pwd)
BASE=$(cd $(dirname $0)/.. && pwd)
WRK2=/Users/bbonacci/work/exp/wrk2/wrk

SERVERS='aleph httpkit jetty'
RQXSEC=${RQXSEC:-500}
CONNECTION=${CONNECTION:-500}
DURATION=${DURATION:-30s}
WARMUP=${WARMUP:-10s}
JVM_OPTS=${JVM_OPTS:-'-server -Xmx1G -Xms1G -XX:+UseG1GC'}
WRK2_OPTS="-t3 -c${CONNECTION} -d${DURATION} -R${RQXSEC} -L"
WRK2_OPTS_WARMUP="-t3 -c${CONNECTION} -d${WARMUP} -R${RQXSEC} -L"

TS=$(date +'%Y-%m-%d_%H-%M-%S')

function wait_for {
    echo "Checking if $1 is started."

    while [ "$(nc -z -w 5 $2 $3 || echo 1)" == "1" ] ; do
        echo "Waiting for $1 to start up..."
        sleep 3
    done
}


cd $BASE

## build all
for i in $SERVERS ; do\
    echo "building ${i}-server"
    cd ${i}-server
    lein do clean, uberjar
    cd $BASE
done

echo "Preparing results' folder..."
mkdir -p $BASE/results/$TS/{simple-get,post-1k}


## test simple GET
for i in $SERVERS ; do\
    echo '======================================================================================='
    echo "testing \"simple HTTP GET\" on ${i}-server"
    # start the server
    java $JVM_OPTS -jar $BASE/${i}-server/target/${i}-server.jar &
    PID=$!

    wait_for ${i}-server 127.0.0.1 3000

    echo '--------------------------------------------------'
    curl -is http://127.0.0.1:3000/ || exit 1
    echo ''
    echo '--------------------------------------------------'

    sleep 3

    export i
    echo "warming up target... this will run for: ${WARMUP}"
    $WRK2 $WRK2_OPTS_WARMUP http://127.0.0.1:3000/ &> /dev/null

    echo '--------------------------------------------------'

    echo "starting test... this will run for: ${DURATION}"
    $WRK2 $WRK2_OPTS http://127.0.0.1:3000/ &> >(tee $BASE/results/$TS/simple-get/${i} )

    echo '--------------------------------------------------'
    echo "Shutting down service"
    kill -9 $PID
    echo "Done"

    sleep 3

    echo "Done"
    echo '======================================================================================='
done



## test POST 1k
for i in $SERVERS ; do\
    echo '======================================================================================='
    echo "testing \"1Kib HTTP POST\" on ${i}-server"
    # start the server
    java $JVM_OPTS -jar $BASE/${i}-server/target/${i}-server.jar &
    PID=$!

    wait_for ${i}-server 127.0.0.1 3000

    echo '--------------------------------------------------'
    curl -is http://127.0.0.1:3000/ || exit 1
    echo ''
    echo '--------------------------------------------------'

    sleep 3

    export i
    echo "warming up target... this will run for: ${WARMUP}"
    $WRK2 $WRK2_OPTS_WARMUP -s $BASE/scripts/post1k.lua http://127.0.0.1:3000/ &> /dev/null

    echo '--------------------------------------------------'

    echo "starting test... this will run for: ${DURATION}"
    $WRK2 $WRK2_OPTS -s $BASE/scripts/post1k.lua http://127.0.0.1:3000/ &> >(tee $BASE/results/$TS/post-1k/${i} )

    echo '--------------------------------------------------'
    echo "Shutting down service"
    kill -9 $PID
    echo "Done"

    sleep 3

    echo "Done"
    echo '======================================================================================='
done


echo "ALL DONE"
find $BASE/results/$TS

cd $CUR

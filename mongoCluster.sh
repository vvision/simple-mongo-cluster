#!/bin/sh

case "$1" in
    start)
        echo "\n\nStarting Replica Set 0.\n"
        mongod --port 21000 --dbpath ./mongodb/rs0/rs0-0 --replSet rs0 --smallfiles --oplogSize 128 --fork --logpath ./mongodb/rs0/rs0-0.log
        mongod --port 21001 --dbpath ./mongodb/rs0/rs0-1 --replSet rs0 --smallfiles --oplogSize 128 --fork --logpath ./mongodb/rs0/rs0-1.log
        mongod --port 21002 --dbpath ./mongodb/rs0/rs0-2 --replSet rs0 --smallfiles --oplogSize 128 --fork --logpath ./mongodb/rs0/rs0-2.log
        
        echo "\n\nStarting Replica Set 1.\n"
        mongod --port 21100 --dbpath ./mongodb/rs1/rs1-0 --replSet rs1 --smallfiles --oplogSize 128 --fork --logpath ./mongodb/rs1/rs1-0.log
        mongod --port 21101 --dbpath ./mongodb/rs1/rs1-1 --replSet rs1 --smallfiles --oplogSize 128 --fork --logpath ./mongodb/rs1/rs1-1.log
        mongod --port 21102 --dbpath ./mongodb/rs1/rs1-2 --replSet rs1 --smallfiles --oplogSize 128 --fork --logpath ./mongodb/rs1/rs1-2.log
        
        echo "\n\nStarting Configuration Servers.\n"
        mongod --configsvr --dbpath ./mongodb/conf/conf0 --port 26000 --fork --logpath ./mongodb/conf/conf0.log
        mongod --configsvr --dbpath ./mongodb/conf/conf1 --port 26001 --fork --logpath ./mongodb/conf/conf1.log
        mongod --configsvr --dbpath ./mongodb/conf/conf2 --port 26002 --fork --logpath ./mongodb/conf/conf2.log
        
        echo "\n\nWaiting before starting the Query Router.\n"
        sleep 17
        
        mongos --configdb localhost:26000,localhost:26001,localhost:26002 --port 24000 --chunkSize 1 --fork --logpath ./mongodb/mongos.log
    
    ;;
    
    stop)
        echo "\n\nShutting down the cluster.\n"
        
        mongo localhost:24000 js/shutdown.js
        
        mongo localhost:26000 js/shutdown.js
        mongo localhost:26001 js/shutdown.js
        mongo localhost:26002 js/shutdown.js
        
        mongo localhost:21000 js/shutdown.js
        mongo localhost:21001 js/shutdown.js
        mongo localhost:21002 js/shutdown.js
        
        mongo localhost:21100 js/shutdown.js
        mongo localhost:21101 js/shutdown.js
        mongo localhost:21102 js/shutdown.js
    ;;
    
    init)
        echo "\n\nCreating directories.\n"
        mkdir -p mongodb/rs0/rs0-0 mongodb/rs0/rs0-1 mongodb/rs0/rs0-2
        mkdir -p mongodb/rs1/rs1-0 mongodb/rs1/rs1-1 mongodb/rs1/rs1-2
        mkdir -p mongodb/conf/conf0 mongodb/conf/conf1 mongodb/conf/conf2
    ;;
    
    configure)
        echo "\n\nConfiguring  the cluster.\n"
        mongo localhost:21000 js/rs0.js
        mongo localhost:21100 js/rs1.js
        sleep 17
        mongo localhost:24000 js/cluster.js
    ;;
    
    clean)
        echo "\n\nCleaning.\n"
        rm -rf mongodb/*
    ;;
    
    *)
        echo "Usage: $prog {init|start|configure|stop|clean}"
        exit 1
    ;;
esac


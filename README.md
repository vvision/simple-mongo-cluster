simple-mongo-cluster
====================

Easily deploy a MongoDB cluster on a single machine for testing purpose.

##Architecture

The cluster is composed of two shards, tree config servers and one query router.
Each shard is a replica set with one primary node and two secondary nodes.

##Port

The following ports are used by the cluster.

Replica Set 1:
* 21000
* 21001
* 21002

Replica Set 2:
* 21100
* 21101
* 21102

Configuration Servers:
* 26000
* 26001
* 26002

Query Router:
* 24000

##Operations

Access to the cluster by connecting to the query router (mongos):

`
    mongo --host localhost --port 24000
`

Enable Sharding for a database :

`
    sh.enableSharding("<database>");
`

Enable Sharding for a Collection :

`   
    sh.shardCollection("<database>.<collection>", {<field>: 1});
`

Check Cluster Status :

`
    sh.status();
    db.<collection>.getShardDistribution();
`

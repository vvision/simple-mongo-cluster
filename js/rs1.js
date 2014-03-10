rsconf = {
    _id: "rs1",
    members: [
        {_id: 0, host: "localhost:21100"},
        {_id: 1, host: "localhost:21101"},
        {_id: 2, host: "localhost:21102"}
    ]
};

rs.initiate(rsconf);

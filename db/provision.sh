#!/bin/bash

git clone https://github.com/metagen/metamind-tools


docker pull dockerfile/mongodb
docker pull dockerfile/rethinkdb

cd metamind-tools/db/
sudo systemctl enable $(pwd)/mongodb.service
sudo systemctl start mongodb.service 
sudo systemctl enable $(pwd)/rethinkdb.service
sudo systemctl start rethinkdb.service 

sudo journalctl -n 15 -u mongodb.service 
sudo journalctl -n 15 -u rethinkdb.service 

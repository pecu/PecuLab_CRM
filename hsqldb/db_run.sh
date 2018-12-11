#!/bin/sh
java -Xmx800M -Dhsqldb.port=9001 -cp ./hsqldb.jar org.hsqldb.server.Server --port 9001 --database.0 file:crx --dbname.0 CRX
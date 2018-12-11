#!/bin/sh
java -cp ./hsqldb.jar org.hsqldb.util.DatabaseManagerSwing --url jdbc:hsqldb:hsql://127.0.0.1:9001/CRX --user sa --password manager99

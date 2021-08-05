#!/bin/sh

java -cp '../../lib/hsqldb-2.6.0.jar:../../target/linearprograming-00-jar-with-dependencies.jar' org.hsqldb.server.Server --database.0 mem:../database/db --dbname.0 database

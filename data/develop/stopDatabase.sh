#!/bin/bash

java -jar ../../lib/sqltool-2.6.0.jar --rcFile=sqlTool.rc --sql 'SHUTDOWN COMPACT;' database

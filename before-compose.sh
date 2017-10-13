#!/bin/sh
#We just create the directories for the volumes so that they are not created by docker-compose with root as the owner
mkdir emr-to-mozart-etl-input
mkdir emr-to-mozart-etl-output

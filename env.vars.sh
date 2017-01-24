#!/bin/bash

###############
#
# Builds and deploys User, Admin, and SuperAdmin Stack WebApps to tomcat server.
# Then starts User webapp so that there is no latency for next user who accesses User webapp.
#
# parameters:
#  1) server type = local|dev|prod|stage
###############

#process arguments
printf "servertype: %s\n" "$1"

if [ "$1" == "" ]
then
	read -p "What server is this? " servertype
else
	servertype=$1;
fi

if [ "$servertype" == "" ]
then
	echo "Server Type not set";
	exit 1;
fi


#Your code deploy apps are
#vststackaws-app-{ENV}
#Your Groups are
#vststackaws-appgroup-{ENV}



if [ "$servertype" == "test" ]
then

    export awsAppName="crossover-test"
	export awsAppGroupName="crossover-grp-test"
	#TODO: switch to suffixed bucket name
	export awsBucketName="cross-over"
	#Access by IAM user 'floe-codedeploy-dev'
    #export AWS_ACCESS_KEY_ID="AKIAILLDMDTWNQXWCKPA"
	#export AWS_SECRET_ACCESS_KEY="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"
	export AWS_DEFAULT_REGION="us-east-1"
fi
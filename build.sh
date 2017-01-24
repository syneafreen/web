#!/bin/bash -v

###############
#
# Builds and deploys User and Admin WebApps to CodeDeploy zips.
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
echo $(pwd)
#chmod +x env.vars.sh
#dos2unix env.vars.sh
. ./env.vars.sh $servertype && echo "environment variables set" || exit 1;
export awsAppName="crossover-test"
export awsAppGroupName="crossover-grp-test"
export AWS_DEFAULT_REGION="us-east-1"
export awsBucketName="cross-over"
mkdir -p server-dist/conf
version=$( date '+%Y%m%d%H%M%S%Z' )
echo $version
cp -v config/index.html server-dist/conf
cp -vr config/server_scripts/ server-dist/conf

cd  server-dist
zip -r dist.zip conf
cp -v ../config/code-deploy/code-deploy-config/appspec.yml server-dist/
cd ..

echo "Deploying stack-app-${version}.zip into ${awsBucketName} bucket of application ${awsAppName} of ${awsAppGroupName} group"
aws deploy push --application-name ${awsAppName} --s3-location s3://${awsBucketName}/app-${version}.zip --ignore-hidden-files --description="${servertype}  Web App" --source server-dist/ || exit 1;

#Triggering CodeDeploy for Stack App 
aws deploy create-deployment --application-name ${awsAppName} --deployment-config-name CodeDeployDefault.OneAtATime --deployment-group-name ${awsAppGroupName} --s3-location bucket=${awsBucketName},key=app.zip,bundleType=zip,key=app-${version}.zip --description "${servertype} Web App Deployment" || exit 1;
echo "JavaServer site built, version: $version"
exit 0; #success

#!/bin/bash -v

############
#
# Adds WARs to tomcat and starts tomcat.
#
############

date >> date2.log

#update server
yum update -y

#copy student and admin web files to tomcat
#cd /usr/share/nginx/htmlAdmin
mkdir -p /var/www/html/
#chmod uo+rw /var/www/html-auth/
mv -v /tmp/cd/dist.zip /var/www/html/ || exit 1
cd /var/www/html
unzip -o dist.zip #-d /var/www/html-admin/
rm -rf dist
mv conf/index.html .
chmod og=r,u=rw index.html
chmod -R a+rx /var/www/html/
service httpd restart



service httpd restart
date >> dateA.log


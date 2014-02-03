#!/bin/bash

# The default defines
TAR_FILE=www.tar.z
ALL_FILES="*.html css/* js/*"
FILES_TO_SEND=all

# See if there is a command line argument
if [ "$#" -eq 1 ]
then
   if [ "$1" == "images-all" ]
   then
      TAR_FILE=images.tar.z
      FILES_TO_SEND=all
      ALL_FILES="images/*"
      echo "Sending all image files to the server"
   else
      TAR_FILE=file.tar.z
      FILES_TO_SEND=$1
      echo "Sending one file to server " $FILES_TO_SEND
   fi
fi

# First delete any existing tar files
if [ -f $TAR_FILE ]
then
  rm $TAR_FILE
fi

# Now figure out which image to upload
if [ $FILES_TO_SEND == "all" ]
then
  echo "Sending all files to the server"
  tar --exclude="*.sh" -zcvf $TAR_FILE $ALL_FILES
else
  echo "Sending $FILES_TO_SEND to the server"
  tar --exclude="*.sh" -zcvf $TAR_FILE $FILES_TO_SEND
fi

# Now push the tar file to the server
scp -i ~/keys/AndrewEC2.pem $TAR_FILE ubuntu@54.200.124.239:~

# Is this for user carl - if so then files need to to to proper directory
if [ $USER == "carl" ]
then
  echo "Installing $TAR_FILE to /var/www/carl/"
  ssh -i ~/keys/AndrewEC2.pem ubuntu@54.200.124.239 "bash -s" < copyfiles.sh $TAR_FILE "carl"
else
  echo "Installing $TAR_FILE to /var/www/"
  ssh -i ~/keys/AndrewEC2.pem ubuntu@54.200.124.239 "bash -s" < copyfiles.sh $TAR_FILE
fi

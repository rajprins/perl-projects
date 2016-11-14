#!/bin/bash

SOURCE=prkill.pl
TARGET=prkill

echo "Compiling file ${SOURCE} to native executable..."
pp -gui ${SOURCE} -o ${TARGET}

if [[ -d "${HOME}/bin" ]] ; then
   echo "Copying executable to local bin directory..."

   if [[ -n $(ps -ef | grep -i prkill | grep -v  grep ) ]] ; then
      echo "Warning! $TARGET seems to be running currently and cannot te replaced."
      echo "Please close $TARGET and run the build process again. Exiting..."
      exit 1
   else
      cp -f ${TARGET} ~/bin/   
   fi
else
   echo "Directory ${HOME}/bin does not seem to exist."
fi

if [ ! -f /usr/share/icons/perl.png ] ; then
   echo "Copying icon..."
   sudo cp -f perl.png /usr/share/icons
fi 

echo "All done."

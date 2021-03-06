#!/bin/bash

# Prechecks
if [ -z "$SHOPWARE_RELEASE_URL" ] ; then
	echo "Variable SHOPWARE_RELEASE_URL is not set. Exiting." > /dev/stdout
	exit 1
fi

if [ -z "$EXTRACT_PATH" ] ; then
	echo "Variable EXTRACT_PATH is not set. Exiting." > /dev/stdout
	exit 1
fi

# Start workflow
echo "Cleaning up $EXTRACT_PATH..." > /dev/stdout
rm -rf $EXTRACT_PATH/*
echo "Done." > /dev/stdout

cd /tmp

if [ ! -f "shopware.zip" ] ; then
	echo "Downloading Shopware release from $SHOPWARE_RELEASE_URL." > /dev/stdout
	wget -q $SHOPWARE_RELEASE_URL -O shopware.zip
fi

echo "Extracting Shopware release to $EXTRACT_PATH." > /dev/stdout
unzip -qq -u shopware.zip -d $EXTRACT_PATH

echo "Setting correct chmods in $EXTRACT_PATH." > /dev/stdout
cd $EXTRACT_PATH
chmod 777 -R .

if [ ! "$FULL_WIPE_ON_REBOOT" = "true" ] ; then
    touch $EXTRACT_PATH/recovery/install/data/install.lock
else
    for i in {1..10}
    do
       echo "!!! WARNING: Env variable FULL_WIPE_ON_REBOOT is set!!!" > /dev/stdout
    done
fi

echo "Done." > /dev/stdout
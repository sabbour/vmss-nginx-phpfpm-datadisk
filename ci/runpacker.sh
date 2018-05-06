#!/bin/bash

IMAGE_NAME="$BASEIMAGE_NAME-$GitVersion_SemVer"

echo "Build number $BUILD_BUILDNUMBER"

echo "************* execute packer build for image $IMAGE_NAME"

## execute packer build and sendout to packer-build-output file
##packer build \
##    -var "client_id=$CLIENT_ID" \
##    -var "client_secret=$CLIENT_SECRET" \
##    -var "tenant_id=$TENANT_ID" \
##    -var "subscription_id=$SUBSCRIPTION_ID" \
##    -var "resource_group=$PACKER_RESOURCE_GROUP" \
##    -var "location=$LOCATION" \    
##    -var "image_name=$BASEIMAGE_NAME-" \
##    #-on-error=abort \ # Uncomment if you want to leave the environment in case of an issue, to debug
##    webserver.json
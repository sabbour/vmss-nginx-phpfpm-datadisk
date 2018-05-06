#!/bin/bash

echo "************* set vars"
CLIENT_ID="@CLIENT_ID@" # Generated using az ad sp create-for-rbac 
CLIENT_SECRET="@CLIENT_SECRET@" # Generated using az ad sp create-for-rbac 
TENANT_ID="@TENANT_ID@"
SUBSCRIPTION_ID="@SUBSCRIPTION_ID@"
RESOURCE_GROUP="@RESOURCE_GROUP@" # Resource Group where images will be stored
LOCATION="@LOCATION@" # Which region to create and store the images, ex: East US
IMAGE_NAME="@IMAGE_NAME@" # Ex: webapp-1.0.1. You should use a unique name per build/version as this will be used to update the VMSS image


echo "************* execute packer build"
## execute packer build and sendout to packer-build-output file
packer build \
    -var "client_id=$CLIENT_ID" \
    -var "client_secret=$CLIENT_SECRET" \
    -var "tenant_id=$TENANT_ID" \
    -var "subscription_id=$SUBSCRIPTION_ID" \
    -var "resource_group=$RESOURCE_GROUP" \
    -var "location=$LOCATION" \    
    -var "image_name=$IMAGE_NAME" \
    #-on-error=abort \ # Uncomment if you want to leave the environment in case of an issue, to debug
    webserver.json
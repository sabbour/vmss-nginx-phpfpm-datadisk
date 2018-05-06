# How to setup the CI/CD pipeline through VSTS

## Prerequisites

I like to tag the images with [Semantic Versioning](https://semver.org/). There is a convenient VSTS Marketplace extension called [GitVersion](https://marketplace.visualstudio.com/items?itemName=gittools.gitversion) that uses information from the branches and commits to do so automatically.

Please install it.

## Build Pipeline

- Select Hosted Build Agent Linux
- Configure variable values in VSTS
- Create Resource Group to host images
- Using a Shell task, download Packer then run it on the repository.

    ```sh
    curl -o packer.zip https://releases.hashicorp.com/packer/1.2.3/packer_1.2.3_linux_amd64.zip

    unzip packer.zip

    mv packer /usr/local/bin

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
    ```

## Release Pipeline

- Run the deployment with the updated image name

    ```sh
    az group create -n packervmssarm -l eastus
    az group deployment create -n deploypackervmssarm -g packervmssarm --template-file azuredeploy.json --parameters azuredeploy.parameters.json
    ```
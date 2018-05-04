# Deploying NGINX and PHP-FPM using Packer to a Virtual Machine Scale Set

## What is this about

Creating a NGINX + PHP-FPM Virtual Machine image using Packer with a bundled application using Packer.

This image will be then used to deploy on a Virtual Machine Scale Set.

## Steps

1. Create Resource Group to store the generated images.

    **Note:** The location of the group should be the same location where you eventually want to deploy the images.

    ```sh
    az group create -n packerimages -l eastus
    ```

1. Create Service Principal, get Client ID, Client Secret and Tenant ID

    ```sh
    az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
    ```

1. Get Subscription ID

    ```sh
    az account show --query "{ subscription_id: id }"
    ```

1. If you intend to run this from your local machine, [install Packer](https://www.packer.io/downloads.html). Otherwise, make sure it is available on your build environment. Packer is already available as a [task on VSTS](https://blogs.msdn.microsoft.com/devops/2017/05/15/deploying-applications-to-azure-vm-scale-sets/).

1. Replace the placeholders in the `packer/runpacker.sh` file (or use a CI/CD tool to inject them)

1. Run Packer

    ```sh
    cd packer
    ./runpacker.sh
    ```

1. The data disk is mounted to `/media/data1/html` which is symlinked to `/usr/share/nginx/html/default`.

1. The content of the `app` directory will be copied to `/usr/share/nginx/html/default` which is where nginx is configured to serve traffic.

1. If you want to edit the provisioning steps, edit `build/provision.sh` script.

## What if you want to use VSTS for CI/CD

Follow [this tutorial](https://blogs.msdn.microsoft.com/devops/2017/05/15/deploying-applications-to-azure-vm-scale-sets/) while using the custom Packer template `packer\webserver.json`.

**TODO:** Write better documentation.

## Deploying to Azure

1. Register for Health Probe provider, to allow for rolling updates (takes around 10 minutes)

    ```sh
    az feature register --name AllowVmssHealthProbe --namespace Microsoft.Network
    ```

    Once the feature `AllowVmssHealthProbe` is registered, invoking `az provider register -n Microsoft.Network` is required to get the change propagated.

1. Run the below manually or through CI/CD.

    Make sure to replace the value of `existingManagedImageName` in `azuredeploy.parameters.json` with the built image name.

    Also double check the resource group names and other values.

    ```sh
    az group deployment create -n deploypackervmssarm -g packervmssarm --template-file azuredeploy.json --parameters azuredeploy.parameters.json
    ```

**TODO:** Write better documentation.
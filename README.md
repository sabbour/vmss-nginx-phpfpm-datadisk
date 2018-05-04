# Deploying NGINX and PHP-FPM using Packer to a Virtual Machine Scale Set

## What is this about

Creating a NGINX + PHP-FPM Virtual Machine image using Packer with a bundled application using Packer.

This image will be then used to deploy on a Virtual Machine Scale Set.

## Steps

1. Create Resource Group to store the generated images

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

1. Replace the placeholders in the `runpacker.sh` file (or use a CI/CD tool to inject them)

1. Run Packer

    ```sh
    ./runpacker.sh
    ```

1. The data disk is mounted to `/media/data1/html` which is symlinked to `/usr/share/nginx/html/default`.

1. The content of the `app` directory will be copied to `/usr/share/nginx/html/default` which is where nginx is configured to serve traffic.

1. If you want to edit the provisioning steps, edit `build/provision.sh` script.

## What if you want to use VSTS for CI/CD

Coming soon.
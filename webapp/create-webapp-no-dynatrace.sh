#!/bin/bash

# Optionally Adjust these
LOCATION=eastus
gitrepo=https://github.com/azure-appservice-samples/JavaCoffeeShopTemplate

# Do not adjust these
WEBAPP_NAME=app-service-dt-from-portal-$RANDOM
RESOURCE_GROUP_NAME=dt-azure-monitoring-demos
WEBAPP_PLAN="$RESOURCE_GROUP_NAME"-plan

clear
echo "================================================"
echo "Creating Azure Resources"
echo "================================================"
echo "Creating a resource group: $RESOURCE_GROUP_NAME"
az group create --location $LOCATION --name $RESOURCE_GROUP_NAME

echo "Creating an App Service plan in FREE tier: $WEBAPP_PLAN"
az appservice plan create --name $WEBAPP_PLAN --resource-group $RESOURCE_GROUP_NAME --sku FREE

echo "Creating Web app: $WEBAPP_NAME"
az webapp create --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP_NAME --plan $WEBAPP_PLAN

echo "Deploying code from a public GitHub repository to Web app: $WEBAPP_NAME"
az webapp deployment source config \
    --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --repo-url $gitrepo \
    --branch master \
    --manual-integration

echo ""
echo "================================================"
echo "WEBAPP_NAME         : $WEBAPP_NAME"
echo "RESOURCE_GROUP_NAME : $RESOURCE_GROUP_NAME"
echo "================================================"
echo "Copy this URL into a browser to see the web app."
echo http://$WEBAPP_NAME.azurewebsites.net
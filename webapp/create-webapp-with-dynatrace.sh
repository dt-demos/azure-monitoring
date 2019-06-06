#!/bin/bash

# Optionally Adjust these
ARM_LOCATION="East US"
LOCATION="eastus"
CODE_GIT_REPO=https://github.com/azure-appservice-samples/JavaCoffeeShopTemplate

# Do not adjust these
WEBAPP_NAME=app-service-dt-from-arm-$RANDOM
RESOURCE_GROUP_NAME=dt-azure-monitoring-demos
WEBAPP_PLAN="$RESOURCE_GROUP_NAME"-plan
DEMO_APP_TEMPLATE_FILE_PATH="./webapp-arm-template.json"
DEMO_APP_PARAMETERS_FILE_PATH="./webapp-parameters.json"

clear
echo "================================================"
echo "Creating Azure Resources"
echo "================================================"
echo "Creating a resource group: $RESOURCE_GROUP_NAME"
az group create --location $LOCATION --name $RESOURCE_GROUP_NAME

echo "Creating an App Service plan in FREE tier: $WEBAPP_PLAN"
az appservice plan create --name $WEBAPP_PLAN --resource-group $RESOURCE_GROUP_NAME --sku FREE

echo "Creating Web app: $WEBAPP_NAME"
az group deployment create \
    --name "$WEBAPP_NAME-deployment" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "$DEMO_APP_TEMPLATE_FILE_PATH" \
    --parameters "@${DEMO_APP_PARAMETERS_FILE_PATH}" \
    --parameters "name=$WEBAPP_NAME" \
    --parameters "hostingPlanName=$WEBAPP_PLAN" \
    --parameters "serverFarmResourceGroup=$RESOURCE_GROUP_NAME" \
    --parameters "location=$ARM_LOCATION"

echo "Deploying code from a public GitHub repository to Web app: $WEBAPP_NAME"
az webapp deployment source config \
    --name $WEBAPP_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --repo-url $CODE_GIT_REPO \
    --branch master \
    --manual-integration

echo ""
echo "================================================"
echo "WEBAPP_NAME         : $WEBAPP_NAME"
echo "RESOURCE_GROUP_NAME : $RESOURCE_GROUP_NAME"
echo "================================================"
echo "Copy this URL into a browser to see the web app."
echo http://$WEBAPP_NAME.azurewebsites.net

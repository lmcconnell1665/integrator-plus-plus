# source ~/.integrator-plus-plus/bin/activate
setup:
	python3 -m venv ~/.integrator-plus-plus

install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

login:
	az login --tenant lbmc.onmicrosoft.com --use-device-code &&\
	az account set --subscription "Luke's Visual Studio Enterprise Subscription"

rg:
	az group create \
	--location eastus \
	--name rg-dev-int-plus-plus \
	--tags cost-center="1" data-classification="conf" environment="Dev" organizational-owner="Luke" workload-infra-owner="luke@lbmc.com" workload-owner="luke@lbmc.com"

spinup:
	az deployment group create \
	--mode Complete \
	--resource-group rg-dev-int-plus-plus \
	--template-file ./iac/main.bicep \
	--parameters ./iac/main.parameters.json

spindown:
	az group delete -n rg-dev-int-plus-plus

lint:
	az bicep build --file iac/main.bicep

flight:
	az deployment group validate \
	--resource-group rg-dev-int-plus-plus \
	--template-file ./iac/main.bicep \
	--parameters ./iac/main.parameters.json
How to Use Resource Templates
==

### presetup

* [azure service principal](https://docs.microsoft.com/ja-jp/cli/azure/create-an-azure-service-principal-azure-cli)

### dependencies

* [azure cli](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli)

### setup azure

* [azure login](https://docs.microsoft.com/ja-jp/cli/azure/authenticate-azure-cli)
* [create service principal](https://docs.microsoft.com/ja-jp/cli/azure/create-an-azure-service-principal-azure-cli)
* [create resource group](https://docs.microsoft.com/ja-jp/cli/azure/group#create)

### setup

```bash
# git clone https://github.com/axsh/minimal-ci-sample.git
# cd minimal-ci-sample.git
```

### create environment

```bash
# cd resource_template/initialize/
# az group deployment validate -g "your_resource_group_here" --template-file azuredeploy.json
# az group deployment create -g "your_resource_group_here" --template-file azuredeploy.json -n "your_deploy_name_here"
```

### launch jenkins

```bash
# cd resource_template/jenkins/
# cp azuredeploy.parameters.json.example azuredeploy.parameters.json
# vim azuredeploy.parameters.json
```

example
```bash
{
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "value": "your_storage_account_name_here"
    },
    "vnetName": {
      "value": "your_vnet_name_here"
    },
    "subnetName": {
      "value": "your_subnet_name_here"
    },
    "adminUsername": {
      "value": "your_login_user_name_here"
    },
    "sshKeyData": {
      "value": "your_ssh_publickey_here"
    },
    "imageUri": {
      "value": "your_target_image_here"
    }
  }
}
```

```bash
# az group deployment validate -g "your_resource_group_here" --parameters @azuredeploy.parameters.json --template-file azuredeploy.json
# az group deployment create -g "your_resource_group_here" --parameters @azuredeploy.parameters.json --template-file azuredeploy.json -n "your_deploy_name_here"
```


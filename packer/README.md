How to Use packer
==

### presetup

* [azure service principal](https://docs.microsoft.com/ja-jp/cli/azure/create-an-azure-service-principal-azure-cli)
* [azure initial setup](https://github.com/axsh/minimal-ci-sample/tree/master/resource_template/README.md)

### build dependencies

* [packer](https://github.com/hashicorp/packer)

### setup

```bash
# git clone https://github.com/axsh/minimal-ci-sample.git
# cd minimal-ci-sample.git
```

### building vmapp(vmimage)

#### jenkins

create variables.json
```bash
# cd packer/jenkins
# cp variables.json.example variables.json
```

example
```json
{
  "client_id": "your_client_id_here",
  "client_secret": "your_client_password_here",
  "subscription_id": "your_subscription_id_here",
  "tenant_id": "your_tenant_id_here",

  "resource_group_name": "minimal-ci-sample",
  "storage_account": "mcssta",

  "jcliuser": "",
  "jclipasswd": ""
}
```

build jenkins vmimage
```bash
# cd packer/jenkins
# ./scripts/compress_jenkins_job.sh
# packer validate -var-file=variables.json template.json
# packer create -var-file=variables.json template.json
```


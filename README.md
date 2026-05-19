# Provision OCI Infrastucture

## Compartments

1. mgmt
    - log analytics, log group, key vault, etc

2. app
    - OKE, workers nodes, Instances, etc

3. data
    - Database, Redis, Block Storage, etc

4. network
    - STG VCN
        - All subnets, Network Security Group, security list, route tables,etc

## VCN, Subnet and IP

VCN_NAME = **stg** 

VCN_CIDR = **10.30.0.0/16**

1. public_lb_subnet = **( 10.30.0.0/24 )**

<!-- 2. cms_oke_woker_subnet = **( 10.10.16.0/20 )**

3. cms_oke_pod_subnet = **( 10.10.128.0/20 )**

4. web_oke_worker_subnet = **( 10.10.30.0/20 )**

5. web_oke_pod_subnet = **( 10.10.112.0/20 )** -->

2. worker_subnet = **( 10.30.96.0/20 )**

3. pod_subnet = **( 10.30.144.0/20 )**

4. db_subnet = **( 10.30.80.0/24 )**

5. private_k8s_api_endpoint_subnet = **( 10.30.60.0/24 )**

6. private_lb_subnet = **( 10.10.55.0/24 )**


## Notifications

### If there's any changes on **Subnets**, **Security List**, **Network Security Group**, **Route Table**, automatically sent alerts to email. Check it out ***notification.tf***


## GitHub Action Workflow

![GHA WorkFlow](images/GHA-ORM.png)

## Requirement for GHA workflow

***In Repository Secrets,*** need to create the following secrets.

**BASTION_SSH_PRIVATE_KEY**

**BASTION_USER**

**OCI_FINGERPRINT** 

**OCI_PRIVATE_KEY**

**OCI_REGION**

**OCI_TENANCY_OCID**

**OCI_USER_OCID**


***In Repository Variables,*** need to create the following variables.

**STACK_ID**

    this stack_id is what you want to trigger from Github Action to OCI Resoure Manager.

***In Environments*** need to create this environment for reviewer and approver process

**stg-oci-infra-apply** 

## Example of create OCI Resource Manger Configuration Source Providers and Stack

- Integrate with github for ***Configuration Source Providers***
- Create ***stack*** with specific repo with the above created ***Configuration Source Providers***

## OKE Architecture

<!-- ![GHA WorkFlow](images/OCI-OKE-Architecture.png) -->

1. Bastionhost can access every cluster
2. Bastionhost can access ssh connection to all worker nodes.
3. Use Native OCI CNI Plugin
# Azure VM Storage Expansion (`azure-vm-storage-expansion`)

Automated DevOps workflow blueprint used to expand root operating system disk partitions and provision secondary block-level volumes inside an active Azure Resource Group layout.

This workspace tracks the end-to-end tasks executed by the Nautilus DevOps team to upgrade virtual machine storage capacities to handle increased infrastructure workloads.

---

## ⚙️ Project Specifications
* **Resource Group:** `kml_rg_main-4f47a4b01e5941fd`
* **Target VM:** `datacenter-vm`
* **OS Disk Name:** `datacenter-vm_OsDisk_1_8fb0c93ac74a4139a19144a5a4991d27`
* **OS Disk Scaling:** Upgraded capacity boundaries from `32Gi` to `64Gi`
* **New Secondary Volume Name:** `datacenter-disk` (64Gi, Standard HDD / `Standard_LRS`)
* **Mount Point Target:** `/mnt/datacenter-disk`

---

## 🛠️ Execution & Deployment Pipeline

### Phase 1: Infrastructure Discovery & Information Gathering
Run these commands from your local shell to map target resource properties:
```bash
# 1. Verify target resource group layout boundaries
az group list --query "[].name" -o tsv

# 2. Extract precise OS Disk Name resource identifiers
az vm show --resource-group kml_rg_main-4f47a4b01e5941fd --name datacenter-vm --query "storageProfile.osDisk.name" -o tsv

# 3. Pull public network entry points (IP Mapping)
az vm list-ip-addresses --resource-group kml_rg_main-4f47a4b01e5941fd --name datacenter-vm --output table

# 4. Fetch the administrative system login handle
az vm show --resource-group kml_rg_main-4f47a4b01e5941fd --name datacenter-vm --query "osProfile.adminUsername" -o tsv

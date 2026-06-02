Phase 1: Gathering Infrastructure Details (From your local machine / Cloud Shell)
Bash
# 1. Find the correct Azure Resource Group name
az group list --query "[].name" -o tsv

# 2. Get the precise OS Disk Name for datacenter-vm
az vm show --resource-group kml_rg_main-4f47a4b01e5941fd --name datacenter-vm --query "storageProfile.osDisk.name" -o tsv

# 3. Find the Public IP address of the VM
az vm list-ip-addresses --resource-group kml_rg_main-4f47a4b01e5941fd --name datacenter-vm --output table

# 4. Find the Administrator Username configured for the VM
az vm show --resource-group kml_rg_main-4f47a4b01e5941fd --name datacenter-vm --query "osProfile.adminUsername" -o tsv
Phase 2: Resizing & Attaching Disks (From your local machine / Cloud Shell)
Bash
# 5. Stop and Deallocate the VM (Required before modifying the primary OS disk)
az vm deallocate --resource-group kml_rg_main-4f47a4b01e5941fd --name datacenter-vm

# 6. Resize the existing OS disk from 32Gi to 64Gi
az disk update --resource-group kml_rg_main-4f47a4b01e5941fd --name datacenter-vm_OsDisk_1_8fb0c93ac74a4139a19144a5a4991d27 --size-gb 64

# 7. Start the VM back up
az vm start --resource-group kml_rg_main-4f47a4b01e5941fd --name datacenter-vm

# 8. Create and Attach the brand new 64Gi Standard HDD Data Disk
az vm disk attach \
  --resource-group kml_rg_main-4f47a4b01e5941fd \
  --vm-name datacenter-vm \
  --name datacenter-disk \
  --size-gb 64 \
  --sku Standard_LRS \
  --new
Phase 3: Connecting & Configuring Storage (Inside the VM)
Bash
# 9. SSH into the Virtual Machine (Replace with your actual IP address found in Step 3)
ssh azureuser@<YOUR_VM_PUBLIC_IP>

# 10. List block storage devices to confirm the new disk (sdc) is visible
lsblk

# 11. Create the target mount directory path
sudo mkdir -p /mnt/datacenter-disk

# 12. Format the new raw storage block device (sdc) with an ext4 filesystem
sudo mkfs.ext4 /dev/sdc

# 13. Mount the storage block device to the target directory
sudo mount /dev/sdc /mnt/datacenter-disk

# 14. Append the mount rule permanently so it mounts automatically on system reboots
echo '/dev/sdc /mnt/datacenter-disk ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab

# 15. Verify that the file system is mounted correctly and shows t

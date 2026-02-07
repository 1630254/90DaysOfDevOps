# Linux Volume Management (LVM)

### Task 1: Check Current Storage
Run: `lsblk`, `pvs`, `vgs`, `lvs`, `df -h`
```bash
lsblk
NAME         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0          7:0    0 27.6M  1 loop /snap/amazon-ssm-agent/11797
loop1          7:1    0   74M  1 loop /snap/core22/2163
loop2          7:2    0 50.9M  1 loop /snap/snapd/25577
nvme0n1      259:0    0    8G  0 disk 
├─nvme0n1p1  259:1    0    7G  0 part /
├─nvme0n1p14 259:2    0    4M  0 part 
├─nvme0n1p15 259:3    0  106M  0 part /boot/efi
└─nvme0n1p16 259:4    0  913M  0 part /boot
nvme1n1      259:5    0    1G  0 disk 
```
```bash
sudo pvs
sudo vgs
sudo lvs

```
```bash
df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root        6.8G  1.8G  5.0G  27% /
tmpfs            458M     0  458M   0% /dev/shm
tmpfs            183M  888K  182M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
efivarfs         128K  3.6K  120K   3% /sys/firmware/efi/efivars
/dev/nvme0n1p16  881M   89M  730M  11% /boot
/dev/nvme0n1p15  105M  6.2M   99M   6% /boot/efi
tmpfs             92M   12K   92M   1% /run/user/1000
```



### Task 2: Create Physical Volume
```bash
sudo pvcreate /dev/nvme1n1
  Physical volume "/dev/nvme1n1" successfully created.

sudo pvs
  PV           VG Fmt  Attr PSize PFree
  /dev/nvme1n1    lvm2 ---  1.00g 1.00g

```


### Task 3: Create Volume Group
```bash
sudo vgcreate devops-vg /dev/nvme1n1
  Volume group "devops-vg" successfully created

sudo vgs
  VG        #PV #LV #SN Attr   VSize    VFree   
  devops-vg   1   0   0 wz--n- 1020.00m 1020.00m

```

### Task 4: Create Logical Volume
```bash
sudo lvcreate -L 500M -n app-data devops-vg
  Logical volume "app-data" created.

sudo lvs
  LV       VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  app-data devops-vg -wi-a----- 500.00m                                                    

```

### Task 5: Format and Mount
```bash
sudo mkfs.ext4 /dev/devops-vg/app-data
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 128000 4k blocks and 128000 inodes
Filesystem UUID: 337d7ae9-a63b-4dcb-975e-602b27a8b457
Superblock backups stored on blocks: 
	32768, 98304

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done
```
```bash
sudo mkdir -p /mnt/app-data
sudo mount /dev/devops-vg/app-data /mnt/app-data
```
```bash
df -h /mnt/app-data
df -h /mnt/app-data
Filesystem                        Size  Used Avail Use% Mounted on
/dev/mapper/devops--vg-app--data  452M   24K  417M   1% /mnt/app-data

```

### Task 6: Extend the Volume
```bash
sudo umount /mnt/app-data 
sudo lvextend -L +200M /dev/mapper/devops--vg-app--data
  Size of logical volume devops-vg/app-data changed from 500.00 MiB (125 extents) to 700.00 MiB (175 extents).
  Logical volume devops-vg/app-data successfully resized.
```
```bash
sudo resize2fs /dev/mapper/devops--vg-app--data
resize2fs 1.47.0 (5-Feb-2023)
Please run 'e2fsck -f /dev/mapper/devops--vg-app--data' first.

sudo e2fsck -f /dev/mapper/devops--vg-app--data
e2fsck 1.47.0 (5-Feb-2023)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/mapper/devops--vg-app--data: 11/128000 files (0.0% non-contiguous), 12302/128000 blocks

sudo resize2fs /dev/mapper/devops--vg-app--data
resize2fs 1.47.0 (5-Feb-2023)
Resizing the filesystem on /dev/mapper/devops--vg-app--data to 179200 (4k) blocks.
The filesystem on /dev/mapper/devops--vg-app--data is now 179200 (4k) blocks long.

sudo mount /dev/devops-vg/app-data /mnt/app-data
```
```bash
df -h /mnt/app-data
Filesystem                        Size  Used Avail Use% Mounted on
/dev/mapper/devops--vg-app--data  637M   24K  588M   1% /mnt/app-data

```
## What I Learned

**1. Storage Initialization & Structure:**
- System storage can be inspected with tools like `lsblk`,`pvs`,`vgs`,`lvs`, and `df -h`. These reveal disks, partitions, physical volumes, volume groups, logical volumes, and filesystem usage — giving a complete picture of available and allocated space.

**2. Logical Volume Management Workflow:**
- The process flows from **creating a physical volume → grouping it into a volume group → carving out logical volumes → formatting and mounting them.** This modular design allows flexible allocation and management of storage resources.

**3. Dynamic Resizing & Scalability:**
- Logical volumes can be extended without recreating them, followed by resizing the filesystem to utilize the new capacity. This ensures scalability and efficient storage management, critical for growing applications and dynamic workloads.
---
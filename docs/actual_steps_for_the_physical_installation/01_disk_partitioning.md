1. First thing to do is to locate the device you want to use for your installation.
```bash
lsblk

NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0         7:0    0 946.7M  1 loop /run/archiso/airootfs
sda           8:0    1  14.8G  0 disk 
└─sda1        8:1    1  14.8G  0 part 
nvme0n1     259:0    0 931.5G  0 disk  
nvme1n1     259:4    0 476.9G  0 disk 
├─nvme1n1p1 259:5    0   100M  0 part 
├─nvme1n1p2 259:6    0    16M  0 part 
├─nvme1n1p3 259:7    0 476.3G  0 part 
└─nvme1n1p4 259:8    0   546M  0 part 
```

In this case I will pick `nvme0n1` and I will partition the disk in the following way:

- `/dev/nvme0n1p1`  EFI System Partition (ESP): 512MB
- `/dev/nvme0n1p2`  SWAP Partition: N GB where N is AT LEAST the RAM capacity of your machine.
- `/dev/nvme0n1p3`  ROOT Partition: use remaining space.

Any partitioning tool can be used, but `cfdisk /dev/nvme0n1` is maybe the simplest.
```
Use "Delete" to remove existing partitions if any.
Select "New" to create a new partition.
Once created use "Type" to select types for the different partitions.
Once the disk has been fully partitioned select "Write" and "Quit".
```

2. Setup Encryption

We want to encrypt the created ROOT Partition and the SWAP partition. The EFI partition is the only partition that can't be encrypted.

LUKS (Linux Unified Key Setup) is the standard disk encryption format on Linux.
- It encrypts data at the **block layer** (via `dm-crypt`), so any filesystem (ex4, btrfs, etc.) can sit on top.
- Your passphrase doesn't encrypt data directly. It unlocks a **master key** stored in the LUKS header. The master key actually encrypts the data.
- You unlock with `cryptsetup open ...`, which creates `/dev/mapper/<name>`; then you format and mount that like a normal device.
- It protects data **at rest** (power off / locked). Once unlocked and mounted, data is accessible to the system.

Starting from the ROOT Partition first we format it, then we are prompted to enter password and finally we open it with that same password:
```bash
cryptsetup luksFormat /dev/nvme0n1p3
cryptsetup open /dev/nvme0n1p3 root
```

Same operations for the SWAP Partition:
```bash
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 swap
```

Format the ROOT Partition to whatever fs you want:
```bash
mkfs.ext4 /dev/mapper/root
```

Format the BOOT Partition:
```
mkfs.fat -F32 /dev/nvme0n1p1
```

Make swap:
```bash
mkswap /dev/mapper/swap
```

Mount everything at `/mnt`:
```
mount /dev/mapper/root /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
swapon /dev/mapper/swap
```

We need to mount the windows EFI partition now, in my case this is `/dev/nvme1n1p1` partition on another disk:
```
mkdir -p /mnt/boot/efi-windows
mount /dev/nvme1n1p1 /mnt/boot/efi-windows
```

Finally, we check the result:
```
lsblk

NAME        MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
loop0         7:0    0 946.7M  1 loop  /run/archiso/airootfs
sda           8:0    1  14.8G  0 disk  
└─sda1        8:1    1  14.8G  0 part  
nvme0n1     259:0    0 931.5G  0 disk  
├─nvme0n1p1 259:1    0   512M  0 part  /mnt/boot
├─nvme0n1p2 259:2    0    16G  0 part  
│ └─swap    253:1    0    16G  0 crypt [SWAP]
└─nvme0n1p3 259:3    0   915G  0 part  
  └─root    253:0    0   915G  0 crypt /mnt
nvme1n1     259:4    0 476.9G  0 disk  
├─nvme1n1p1 259:5    0   100M  0 part  /mnt/boot/efi-windows
├─nvme1n1p2 259:6    0    16M  0 part  
├─nvme1n1p3 259:7    0 476.3G  0 part  
└─nvme1n1p4 259:8    0   546M  0 part  
```

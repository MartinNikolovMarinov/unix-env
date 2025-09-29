# Description

This step-by-step guide shows how to install Windows 11 and Arch Linux Minimal in a Dual Boot configuration, with encryption using both BitLocker and LuksFormat for linux. This configuration encrypts the swap partition as well.

# Table of Contents

0. Prerequisites
1. Prepare the Virtual Machine
    1. Create the Virtual Machine
    2. Configure VirtualBox Settings
    3. Create Virtual Hard Disks
2. Install Windows 11
3. Install Arch Linux
    1. Boot into the Arch Linux Live Environment
    2. Verify UEFI Boot Mode
    3. Connect to the Internet
    4. Update the System Clock
4. Partition the Disks
    1. Identify Disks
    2. Partition /dev/sdb for Arch Linux
5. Set Up LUKS Encryption
    1. Encrypt the Root Partition
    2. Encrypt the Swap Partition
6. Format and Mount Filesystems
    1. Format Partitions
    2. Mount Filesystems
7. Install Essential Packages with pacstrap
8. Generate fstab
9. Chroot into the New System
10.  Configure the System
    1. Time Zone and Localization
    2. Hostname and Hosts File
10. Configure Initramfs for Encryption
11. Install Boot Loader
12. Configure Encrypted Swap
13. Set Root Password and Create a User
14. Enable Network Manager
15. Finalize Installation
16. Reboot and Test the Installation

# Prerequisites

* VirtualBox installed on your host machine.
* Windows 11 ISO.
* Arch Linux ISO (latest version from Arch Linux Downloads).
* Stable Internet Connection.

## Step 1: Prepare the Virtual Machine

### 1.1. Create the Virtual Machine

    Open VirtualBox.
    Click on "New" to create a new VM.
    Name the VM (e.g., DualBoot).
    Type: What ever you want.
    Version: What ever you want.
    Disk and ISO image: Skip adding iso image or creating a virtual disk. This will be done later.
    Memory Size: Allocate at least 4 GB (4096 MB).
    Processor: Allocate at least 2 CPUs. (Windows requires at least 2, but you should use 4 or more)
    Enable EFI (special OSes only): should be checked to use UEFI.

### 1.2. Configure VirtualBox Settings

    Select the VM and click on "Settings".
    System:
        Motherboard:
            Enable "EFI" under Extended Features. Make sure this is checked.
            TPM enable version 2.
            Secureboot: When the Arch Linux Live CD is booted we will have to stop secure boot option.
    Display:
        Video Memory: Set to 128 MB. (Should be set to at least that by default)
    Network:
        Ensure "Adapter 1" is attached to "NAT". (The default should work fine)

### 1.3. Create Virtual Hard Disks

Create two virtual hard disks:

    Windows Disk: For Windows 11 installation.
    Arch Disk: For Arch Linux installation.

    Add the Windows Disk:
        Under "Storage", select "Controller: SATA".
        Click on the "Add Hard Disk" icon (the disk with a plus sign).
        Choose "Create".
        VDI (VirtualBox Disk Image).
        Dynamically allocated.
        Size: At least 70 GB. (Windows needs at least 52-54G)
        Name: WindowsDisk.vdi.

    Add the Arch Linux Disk:
        Under "Storage", select "Controller: SATA".
        Click on the "Add Hard Disk" icon (the disk with a plus sign).
        Choose "Create".
        VDI (VirtualBox Disk Image).
        Dynamically allocated.
        Size: At least 20G.
        Name: ArchLinuxDisk.vdi.

    Add the Windows install iso:
        Under "Storage", select "Controller: Sata".
        Click on the "Add Optical Disk" icon
        Choose "Add" and choose the Windows iso
        You might need to check the Live CD/DVD option for the Windows iso disk. Likely not needed.

## Step 2: Install Windows 11

    Start the VM.
    Proceed with Windows 11 installation:
        Follow the on-screen instructions.
        Select Custom Installation when prompted.
        Select the WindowsDisk.vdi disk (usually shown as Drive 0). Should be of size 70 (or whatever you set it to).
        Install Windows 11 on this disk.
        Turn off internet to force Windows 11 to create a local account and not require windows online account. This needs to happen at a specific time, check the internet for articles on how to do this exactly.

IMPORTANT: Ensure Windows is fully installed and functional before proceeding.

## Step 3: Install Arch Linux

### 3.1. Boot into the Arch Linux Live Environment

    Shut down the VM after Windows installation.
    Detach the Windows 11 ISO and attach the Arch Linux ISO.
    Don't forget to uncheck Secure Boot if selected previously.
    Start the VM.
    At this point the VM will boot from the Windows Virtual Disk.
    The only way to avoid this is to press F2 very quickly after the vm boots.
    This is very hard to do because the Windows bootloader starts almost immediately. Just keep starting the machine and pressing f2 very quickly!
    Once you get to the boom menu select "Boot Maintenance Manager > Boot Options > Change Boot Order" and reorder the bootorder so that the Arch optical drive boots first (it is likely named somthing CD-ROM).
    Alternatively you can Select to boot from the cd directly. There might be an option for this somewhere.
    Save the configuration and reboot.
    Next time you should be able to boot into the live CD and install Arch.

### 3.2. Verify UEFI Boot Mode

```bash
ls /sys/firmware/efi/efivars
```
If the directory exists and contains files, you are in UEFI mode. If not, you need a different tutorial for dual boot in legacy boot mode.

### 3.3. Connect to the Internet

Check network connection:
```bash
    ping -c 3 archlinux.org
```
If not connected, use dhcpcd:

```bash
    systemctl start dhcpcd
```
For Wi-Fi connections, use iwctl:
```bash
iwctl

Inside iwctl:
    device list
    station <device_name> scan
    station <device_name> get-networks
    station <device_name> connect <SSID>

    Replace <device_name> with your wireless device name and <SSID> with your Wi-Fi network name.
```

### 3.4. Update the System Clock

```bash
timedatectl set-ntp true
```

## Step 4: Partition the Disks

### 4.1. Identify Disks

```bash
lsblk
```

You should see:
```bash
    /dev/sda: The disk with Windows 11 installed (WindowsDisk.vdi).
    /dev/sdb: The disk for Arch Linux (ArchDisk.vdi).
```

### 4.2. Partition /dev/sdb for Arch Linux

Create:

* EFI System Partition (ESP): 512 MB, /dev/sdb1.
* Swap Partition: 4 GB, /dev/sdb2.
* Root Partition: Remaining space, /dev/sdb3.

### 4.2.1. Launch cfdisk /dev/sdb, or whatever utility

* Create the EFI System Partition (ESP)

    Select "New" to create a new partition.
    Size: Enter 512M for 512 Megabytes.
    Type:
        After specifying the size, select the partition type.
        Choose EFI System from the list. If not listed, set the type to EFI (FAT-32) or manually enter the type code EF00.
    Write Changes:
        After configuring, ensure the partition is marked correctly.
        Repeat these steps for the next partitions.

* Create the Swap Partition

    Select "New" to create another partition.
    Size: Enter 4G for 4 Gigabytes.
    Type:
        Choose Linux swap from the list. If not listed, set the type to Linux swap or manually enter the type code 8200.
    Write Changes:
        Verify the partition type is correct.

* Create the Root Partition

    Select "New" to create the final partition.
    Size: Press Enter to use the remaining available space.
    Type:
        Choose Linux filesystem from the list. If not listed, set the type to Linux or manually enter the type code 8300.
    Write Changes:
        Ensure the partition type is correctly set.

### 4.2.2 Write and Exit cfdisk

    Select "Write" from the menu.
    Confirm: Type yes when prompted to apply the changes.
    Exit: After writing, select "Quit" to exit cfdisk.

### 4.2.3 Verify Partitions

```bash
lsblk

You should see:
    /dev/sdb1: 512 MB
    /dev/sdb2: 4 GB
    /dev/sdb3: Remaining space
```

## Step 5: Set Up LUKS Encryption

### 5.1. Encrypt the Root Partition

### 5.1.1. Initialize LUKS on /dev/sdb3

```bash
cryptsetup luksFormat /dev/sdb3
```
Type YES (uppercase) to confirm. Enter a strong passphrase when prompted.

### 5.1.2. Open the Encrypted Root Partition

```bash
cryptsetup open /dev/sdb3 cryptroot
```
Enter your LUKS passphrase when prompted.

### 5.2. Encrypt the Swap Partition

We will set up the swap partition to be encrypted with a random key at each boot, ensuring security without requiring a passphrase.

Note: Do not format or activate swap on /dev/sdb2 at this point.

## Step 6: Format and Mount Filesystems

### 6.1. Format Partitions
### 6.1.1. Format the Encrypted Root Partition

```bash
mkfs.ext4 /dev/mapper/cryptroot
```

### 6.1.2. Format the EFI System Partition

```bash
mkfs.fat -F32 /dev/sdb1
```

### 6.1.3. Do Not Format the Swap Partition

We will configure encrypted swap later.

## 6.2. Mount Filesystems

## 6.2.1. Mount the Encrypted Root Partition

```bash
mount /dev/mapper/cryptroot /mnt
```

## 6.2.2. Create and Mount the EFI Directory

```bash
mkdir -p /mnt/boot
mount /dev/sdb1 /mnt/boot
```

## Step 7: Install Essential Packages with pacstrap

Install the base system and additional packages:

```bash
pacstrap /mnt base linux linux-firmware grub efibootmgr dosfstools os-prober mtools networkmanager sudo vim micro htop which git
```
    Packages Included:
        base: Essential system packages.
        linux: The Linux kernel.
        linux-firmware: Firmware for hardware devices.
        grub: Boot loader.
        efibootmgr, dosfstools, os-prober, mtools: Utilities for boot loader and filesystem management.
        networkmanager: For network management.
        sudo: Allows users to run commands with superuser privileges.
        vim/micro: Text editor (optional, can be replaced with your preferred editor).
        htop: interactive process viewer
        which: locate a command
        git: git client

There is a lot more to install, but this is a minimal install example.

## Step 8: Generate fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```
Verify fstab:
```bash
cat /mnt/etc/fstab
```

Ensure the entries for / and /boot are correct.

## Step 9: Chroot into the New System

```bash
arch-chroot /mnt
```

## Step 10: Configure the System
### 10.1. Time Zone and Localization
### 10.1.1. Set Time Zone

```bash
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
```

Replace Region/City with your time zone (e.g., America/New_York).

### 10.1.2. Localization

Edit locale.gen:

```bash
nano /etc/locale.gen

Uncomment en_US.UTF-8 UTF-8
```
Generate Locales:
```bash
locale-gen
```
Set Locale:
```bash
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

## 10.2. Hostname and Hosts File
### 10.2.1. Set Hostname

```bash
echo "tester" > /etc/hostname
```

### 10.2.2. Configure Hosts File

```bash
nano /etc/hosts
```

Add the following lines:

```bash
127.0.0.1   localhost
::1         localhost
127.0.1.1   tester.localdomain   tester
```

Explanation:

* 127.0.0.1 and ::1 are standard loopback entries.
* 127.0.1.1 maps your chosen hostname → this is important so local services resolve it properly.
* You can replace localdomain with your actual local domain if you have one, but localdomain is a safe default.

## Step 11: Configure Initramfs for Encryption
### 11.1. Edit /etc/mkinitcpio.conf

```bash
nano /etc/mkinitcpio.conf
```
Modify the HOOKS line to include `encrypt` and `resume`:

HOOKS=(...other block... encrypt resume)

Place encrypt after block.

### 11.2. Recreate Initramfs

```bash
mkinitcpio -P
```

## Step 12: Install Boot Loader
### 12.1. Identify the UUID of /dev/sdb3

```bash
blkid /dev/sdb3
```

Note down the UUID (not PARTUUID) of /dev/sdb3. Example: b2e9cd65-0f29-4b75-b7c4-fcf538038a66

## 12.2. Edit /etc/default/grub

```bash
micro /etc/default/grub
```

Add or modify the following lines:

Enable cryptodisk support:

GRUB_ENABLE_CRYPTODISK=y

Modify GRUB_CMDLINE_LINUX:

GRUB_CMDLINE_LINUX="cryptdevice=UUID=YOUR_UUID:cryptroot root=/dev/mapper/cryptroot"

Replace YOUR_UUID with the UUID of /dev/sdb3.

Enable OS Prober:

GRUB_DISABLE_OS_PROBER=false

## 12.3. Mount the Windows EFI Partition
### 12.3.1. Identify the Windows EFI Partition

```bash
lsblk -f
```
Look for a small partition on /dev/sda with the vfat filesystem, likely /dev/sda1.

### 12.3.2. Create Mount Point and Mount It

```bash
mkdir /boot/efi-windows
mount /dev/sda1 /boot/efi-windows
```

### 12.4. Install GRUB to the EFI System

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

### 12.5. Generate GRUB Configuration

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

GRUB should detect Windows and include it in the boot menu.

## Step 13: Configure Encrypted Swap
### 13.1. Edit /etc/crypttab

```bash
nano /etc/crypttab
```

Add the following line:

```bash
cryptswap	/dev/sdb2	/dev/urandom	swap,cipher=aes-xts-plain64,size=256
```

This sets up an encrypted swap partition using a random key at each boot.

### 13.2. Edit /etc/fstab

```bash
nano /etc/fstab
```

Add the following line:

```bash
/dev/mapper/cryptswap	none	swap	defaults	0 0
```

### 13.3. Rebuild the Initramfs

```bash
mkinitcpio -P
```

## Step 14: Set Root Password and Create a User
### 14.1. Set Root Password

```bash
passwd
```
Enter and confirm the new root password.

### 14.2. Create a New User

```bash
useradd -mG wheel,audio,video username
passwd username
```

Replace username with your desired username.

### 14.3. Configure Sudo

```bash
nano /etc/sudoers

Uncomment the following line:
%wheel ALL=(ALL) ALL
```

## Step 15: Enable Network Manager

```bash
systemctl enable NetworkManager
```

## Step 16: Finalize Installation
### 16.1. Exit Chroot and Unmount Partitions

```bash
exit
umount -R /mnt
swapoff -a
cryptsetup close cryptroot
```

### 16.2. Reboot

Remove the Arch Linux ISO from the VM's virtual optical drive.

Reboot the system:
```bash
reboot
```

## Step 17: Reboot and Test the Installation

### 17.1. GRUB Boot Menu

On reboot, you should see the GRUB menu with options for Arch Linux and Windows Boot Manager. You might need to poweroff and remove the optical drive from the virtual machine Storage settings.

### 17.2. Enter LUKS Passphrase

When you select Arch Linux, GRUB will prompt you for the LUKS passphrase to unlock the encrypted root partition.

### 17.3. Log In

Log in with the user account you created.

### 17.4. Verify Encrypted Swap

```bash
swapon --show
```

You should see the swap partition.

### 17.5. Boot into Windows 11

Reboot the System
Select "Windows Boot Manager" in GRUB
Ensure that Windows 11 boots successfully.
Might show a blue screen the first time.

# Start initial system configurations

Set the timezone:
```bash
ln -sf /usr/share/zoneinfo/Europe/Sofia /etc/localtime
hwclock --systohc
```

Edit the `/etc/locale.gen` and uncomment `en_US.UTF-8 UTF-8`, or whatever localization you want, then run:
```bash
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
```

Set the hostname (replace `<HOSTNAME>` with the value you intend to use):
```bash
echo "<HOSTNAME>" > /etc/hostname
```

> **Note:** Keep the real hostname in private documentation if required; the placeholders prevent exposing active hostnames in public repos.

Edit the `/etc/hosts` file in the following way:
```bash
cat /etc/hosts

# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1        localhost
::1              localhost
127.0.1.1        <HOSTNAME>
```

The host name will not change until a reboot, so you can change it like this:
```bash
hostnamectl set-hostname <HOSTNAME>
```

To see if the change took place you can `ping <HOSTNAME>`, or do this:
```bash
hostnamectl

 Static hostname: <HOSTNAME>
       Icon name: computer-desktop
         Chassis: desktop
      Machine ID: <REDACTED>
         Boot ID: <REDACTED>
    Product UUID: <REDACTED>
Operating System: Arch Linux
          Kernel: Linux <KERNEL_VERSION>
    Architecture: x86-64
 Hardware Vendor: <VENDOR>
  Hardware Model: <MODEL>
 Hardware Serial: <REDACTED>
Firmware Version: <FIRMWARE_VERSION>
   Firmware Date: <FIRMWARE_DATE>
    Firmware Age: <FIRMWARE_AGE>
```

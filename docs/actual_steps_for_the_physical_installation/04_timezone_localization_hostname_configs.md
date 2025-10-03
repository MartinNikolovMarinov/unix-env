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

Set the hostname:
```bash
echo "good-mood14" > /etc/hostname
```

Edit the `/etc/hosts` file in the following way:
```bash
cat /etc/hosts

# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1        localhost
::1              localhost
127.0.1.1        good-mood14
```

The host name will not change until a reboot, so you can change it like this:
```bash
hostnamectl set-hostname good-mood14
```

To see if the change took place you can `ping good-mood14`, or do this:
```bash
hostnamectl

 Static hostname: good-mood14
       Icon name: computer-desktop
         Chassis: desktop 🖥️
      Machine ID: c40d89bf558f46cd9d4102e9d2742c10
         Boot ID: 1eadce5460b049fbae3aeef3abde24f4
    Product UUID: eebbaced-746a-fe10-c0e3-2cfda1c05df1
Operating System: Arch Linux
          Kernel: Linux 6.16.4-arch1-1
    Architecture: x86-64
 Hardware Vendor: ASUSTeK COMPUTER INC.
  Hardware Model: PRIME Z370-A
 Hardware Serial: System Serial Number
Firmware Version: 0605
   Firmware Date: Fri 2017-12-01
    Firmware Age: 7y 9month 4w 1d
```

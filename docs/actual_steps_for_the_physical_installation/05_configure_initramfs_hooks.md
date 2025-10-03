# Configure initramfs for Encryption and Hybernation

IMPORTANT: I use systemd here instead of the default busybox configuratuin, which did not work for my setup.

Edit the `/etc/mkinitcpio.conf` file to add `sd-encrypt` and `sd-resume`, the file should look something like this:
```bash
sed -n '/^[[:space:]]*HOOKS=/p' /etc/mkinitcpio.conf

HOOKS=(base systemd autodetect modconf kms keyboard keymap block sd-encrypt resume filesystems fsck)
```

Configure the Encrypted Swap next by editing the `/etc/crypttab` 
```bash
cat /etc/crypttab

# Configuration for encrypted block devices.
# See crypttab(5) for details.

# NOTE: Do not list your root (/) partition here, it must be set up
#       beforehand by the initramfs (/etc/mkinitcpio.conf).

# <name>       <device>                                     <password>              <options>
# home         UUID=b8ad5c18-f445-495d-9095-c9ec4f9d2f37    /etc/mypassword1
# data1        /dev/sda3                                    /etc/mypassword2
# data2        /dev/sda5                                    /etc/cryptfs.key
# swap         /dev/sdx4                                    /dev/urandom            swap,cipher=aes-cbc-essiv:sha256,size=256
# vol          /dev/sdb7                                    none

swap /dev/nvme0n1p2 none luks,discard
```

Finally, rebuild initramfs:
```bash
mkinitcpio -P
```

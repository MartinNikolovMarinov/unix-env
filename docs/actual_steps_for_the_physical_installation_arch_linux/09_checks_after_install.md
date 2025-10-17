# Checks after install

```bash
swapon --show
cat /proc/cmdline 					# make sure resume=/dev/mapper/swap exists
grep HOOKS /etc/mkinitcpio.conf 	# make sure sd-encrypt and resume are available
systemctl hibernate                 # trigger hibernation to verify
journalctl -b | grep -i resume      # verify that resume was attempted
dmesg | grep -i resume              # verify that resume was attempted
```

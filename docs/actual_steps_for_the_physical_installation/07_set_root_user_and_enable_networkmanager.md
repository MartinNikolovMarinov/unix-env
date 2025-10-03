# Set the root user and configure the network manager

Set the root password:
```bash
passwd
```

Create a new user:
```bash
useradd -mG wheel,audio,video good-mood14
passwd good-mood14
```

Configure sudoers by editing `/etc/sudoers` uncomment the following line:
```
%wheel ALL=(ALL) ALL
```

Enable Network Manager
```
systemctl enable NetworkManager
```

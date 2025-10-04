# Set the root user and configure the network manager

Set the root password:
```bash
passwd
```

Create a new user (replace `<USERNAME>` with the account name you intend to use):
```bash
useradd -mG wheel,audio,video <USERNAME>
passwd <USERNAME>
```

Configure sudoers by editing `/etc/sudoers` uncomment the following line:
```
%wheel ALL=(ALL) ALL
```

Enable Network Manager
```
systemctl enable NetworkManager
```

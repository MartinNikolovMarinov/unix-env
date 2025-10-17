# Install and configure GRUB on the EFI System

IMPORTANT: The following is the most error prone step of the entire process, so pay attenton.

Edit the `/etc/default/grub` file, by

- Uncomment GRUB_ENABLE_CRYPTTODISK=y
- Uncomment GRUB_DISABLE_OS_PROBER=false
- Modify the variable GRUB_CMDLINE_LINUX="rd.luks.name=${ROOT_UUID}=root rd.luks.name=${SWAP_UUID}=swap rd.luks.options=${ROOT_UUID}=discard rd.luks.options=${SWAP_UUID}=discard root=/dev/mapper/root resume=/dev/mapper/swap
"

NOTE: It's hard to set the GRUB_CMDLINE_LINUX variable, so make some helper variables first:
```
export SWAP_UUID=$(blkid -s UUID -o value /dev/nvme0n1p2)
export ROOT_UUID=$(blkid -s UUID -o value /dev/nvme0n1p3)
export GRUB_CMDLINE_LINUX=$("echo rd.luks.name=${ROOT_UUID}=root rd.luks.name=${SWAP_UUID}=swap rd.luks.options=${ROOT_UUID}=discard rd.luks.options=${SWAP_UUID}=discard root=/dev/mapper/root resume=/dev/mapper/swap
")
```

Install GRUB:
```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

Make sure `os-prober` finds windows boot manager, otherwise it might not have mounted correctly in the previous steps:
```bash
os-prober

/dev/nvme1n1p1@/EFI/Microsoft/Boot/bootmgfw.efi:Windows Boot Manager:Windows:efi
```

Finally, create the grub configuration:
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

Cat to make sure there is a Windows entry:
```
cat /boot/grub/grub.cfg | grep -e windows

menuentry 'Windows Boot Manager (on /dev/nvme1n1p1)' --class windows --class os $menuentry_id_option 'osprober-efi-9432-949C' {
```

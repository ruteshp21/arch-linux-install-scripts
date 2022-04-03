#!/bin/bash

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
timedatectl set-ntp true
hwclock --systohc
sed -i '169s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_IN.UTF-8" >> /etc/locale.conf
echo "LC_ALL=en_IN.UTF-8" >> /etc/environment
echo "KEYMAP=us" >> /etc/vconsole.conf
echo "zenbox" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 zenbox.localdomain zenbox" >> /etc/hosts
echo root:password | chpasswd

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S --needed grub efibootmgr networkmanager os-prober network-manager-applet pacman-contrib nano vim base-devel bash-completion usbutils lsof dialog linux-firmware linux-headers neofetch zip unzip unrar p7zip lzop rsync openssh cronie xdg-user-dirs samba bluez bluez-libs bluez-utils gvfs gvfs-smb dosfstools ntfs-3g btrfs-progs exfat-utils fuse2 fuse3 fuseiso smbclient alsa-utils alsa-plugins pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer cups hplip ghostscript cups-pdf wpa_supplicant mtools avahi xdg-utils nfs-utils inetutils dnsutils reflector acpi acpi_call qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset sof-firmware nss-mdns acpid terminus-font xorg-server xorg-xinit xorg-xprop xorg-xrdb xorg-xsetroot xorg-xrandr xf86-input-libinput gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad gst-libav

pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch #change the directory to /boot/efi is you mounted the EFI partition at /boot/efi
sed -i '3s/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' /etc/default/grub
sed -i '54s/.//' /etc/default/grub
sed -i '63s/.//' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable smb.service
systemctl enable sshd
systemctl enable cronie
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable acpid

useradd -m rutesh
echo rutesh:password | chpasswd
usermod -aG wheel rutesh

sed -i 's/MODULES=()/MODULES=(btrfs nvidia)/' /etc/mkinitcpio.conf
echo "options hid_apple fnmode=2" | tee /etc/modprobe.d/hid_apple.conf
mkinitcpio -p linux

printf "\e[1;32mDone! Type exit, edit using visudo, umount -a and reboot.\e[0m"

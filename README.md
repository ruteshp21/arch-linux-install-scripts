# Arch Linux Installation Steps
This document contains steps for installing *Arch Linux* with __BTRFS__ and __ZRAM__.

## Step 1: Update the system clock
`timedatectl set-ntp true`

## Step 2: Update pacman repositories
`pacman -Sy`

## Step 3: Create file system (btrfs) with root and home partition
```
mkfs.btrfs -f /dev/nvme0n1p4 
mount /dev/nvme0n1p4 /mnt
cd /mnt 
btrfs subvolume create @ 
btrfs subvolume create @home
cd umount /mnt
mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ /dev/nvme0n1p4 /mnt 
mkdir /mnt/{boot,home} 
mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home /dev/nvme0n1p4 /mnt/home 
mount /dev/nvme0n1p1 /mnt/boot 
```
## Step 4: Install essential packages
`pacstrap /mnt base linux linux-firmware nano vim git amd-ucode`

## Step 5: Configure the system fstab
`genfstab -U /mnt >> /mnt/etc/fstab`

## Step 6: Post installation access installed system via chroot
`arch-chroot /mnt`

## Step 7: Clone this repo
`git clone https://github.com/ruteshp21/arch-linux-installer.git`

## Step 8: Run following shell script to install add-on essential package and configure Arch system
`./arch-essential-pkg.sh`

## Step 9: Add wheel group to sudo
`EDITOR=nano visudo`

## Step 10: Unmount and restart
```
exit
umount -R /mnt
```

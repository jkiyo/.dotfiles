# .dotfiles

### Installing

The install is only for Arch Linux. First, boot from a flash Arch linux drive.

Once in Arch linux, connect to the internet via cable, or Wifi (see usage in [iwctl](https://wiki.archlinux.org/title/Iwd)).

Now, install git with pacman, and clone this repository.

```bash
pacman -S git
git clone https://github.com/jkiyo/.dotfiles.git
```

After cloning the repository, run the `base` install script.

```bash
cd .dotfiles
bash install/base.sh
```

When this script finishes, run `arch-chroot /mnt`, and then run the `setup` script.

```bash
bash install/setup.sh
```

Now you're good to reboot your system, and run the next `user` script after login with your user.

```bash
# First check if you're connect to internet
nmcli device wifi list
nmcli device wifi connect <SSID> password <PASSWORD>

# Then, clone this repository again, now to your user's home
git clone https://github.com/jkiyo/.dotfiles.git ~/.dotfiles

# Finally, run the script
cd ~/.dotfiles
bash install/user.sh
```

You're done! Reboot and enjoy.
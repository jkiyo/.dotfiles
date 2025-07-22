# .dotfiles

## Installing

The install is only for Arch Linux. First, boot from a flash Arch linux drive.

Once in Arch linux, connect to the internet via cable, or Wifi (see usage in
[iwctl](https://wiki.archlinux.org/title/Iwd)).

### Install base.sh

First, install git with pacman, and clone this repository.

```bash
pacman -S git
git clone https://github.com/jkiyo/.dotfiles.git
```

After cloning the repository, run the `base.sh` install script.

```bash
cd .dotfiles
bash install/base.sh
```

When this script finishes, run `arch-chroot /mnt` to change into the new
installed Arch root.

### Install setup.sh

After running `arch-chroot` command, clone this repository again.

```bash
git clone https://github.com/jkiyo/.dotfiles.git
```

And run the `setup.sh` script.

```bash
cd .dotfiles
bash install/setup.sh
```

Now you're good to reboot your system.

### Install user.sh

After a reboot, and logged in in to the fresh Arch installation, connect to
the internet (see [nmcli](https://wiki.archlinux.org/title/NetworkManager)).

```bash
nmcli device wifi list
nmcli device wifi connect <SSID> password <PASSWORD>
```

Then, clone this repository, again, now to your user's home.

```bash
git clone https://github.com/jkiyo/.dotfiles.git ~/.dotfiles
```

Finally, run the script (it might ask for sudo permissions).

```bash
cd ~/.dotfiles
bash install/user.sh
```

You're done! Reboot and enjoy.
# dotfiles  
[![Build Status](https://travis-ci.org/casjay-dotfiles/minimal.svg?branch=master)](https://travis-ci.org/casjay-dotfiles/minimal) [![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://www.patreon.com/casjay) [![Paypal](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/casjaysdev) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/32421d1b17a04d88a7a141c5fd720f0c)](https://www.codacy.com/manual/casjay/minimal?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=casjay-dotfiles/minimal&amp;utm_campaign=Badge_Grade)  

Linux Config Files  
A relative minimal install  
[Have a suggestion?](https://github.com/casjay-dotfiles/minimal/issues) Go to issues!

#### All Unix and Linux  
Preresquites  
Packages not avialable in Redhat/Debian repos  
youtube-viewer - https://github.com/trizen/youtube-viewer  
##### Debian Based
```bash
sudo apt install git curl gnupg python3 python3-pil libjpeg-dev vim-nox neomutt isync msmtp pass lynx notmuch abook urlview newsboat mplayer mpc mpd pianobar net-tools mpv ctags build-essential fim emacs-nox
```
##### Redhat based
```bash
sudo yum install git curl gnupg python3 neomutt isync msmtp pass lynx notmuch abook urlview newsboat mplayer mpc mpd pianobar net-tools mpv ctags
```
##### Arch based
```bash
sudo pacman -Syyu git curl gnupg python3 python-pip neomutt isync msmtp pass lynx notmuch abook newsboat mplayer mpc mpd youtube-viewer pianobar net-tools mpv ctags
sudo yay -S urlview
```
### Automated Install  
```bash
bash -c "$(curl -LsS https://raw.githubusercontent.com/casjay-dotfiles/minimal/master/install.sh)"
```

### Update the dotfiles  
```bash
bash -c "$(curl -LsS https://raw.githubusercontent.com/casjay-dotfiles/minimal/master/install.sh)"
```

### Manual Install  
##### Yum based distros:  
```shell
sudo yum install epel-release redhat-lsb git curl wget vim tmux zsh fish sudo neofetch \
gnupg net-tools powerline htop lsof mercurial bzr strace cowsay thefuck screen subversion
```
##### Apt based distros:  
```shell
sudo apt-get install lsb-release git curl wget vim tmux zsh fish sudo neofetch gnupg \
net-tools powerline htop lsof mercurial bzr strace cowsay thefuck screen subversion
```
##### Pacman based Distro:  
```shell
sudo pacman -Syy lsb-release git curl wget vim tmux zsh fish sudo neofetch gnupg \
net-tools powerline htop lsof mercurial bzr strace cowsay thefuck screen subversion
```
#### Windows install  
```shell
git clone https://github.com/casjay-dotfiles/minimal.git /tmp/dotfiles
cp -Rfva /tmp/dotfiles/etc/skel/. ~/
mv -fv ~/.config/bash/profile/.alias.win ~/.config/bash/profile/00-alias.bash
mv -fv ~/.config/bash/profile/.profile.win ~/.config/bash/profile/00-profile.bash
mv -fv ~/.config/bash/profile/.powerline.win ~/.config/bash/profile/01-powerline.bash
rm -Rfv /tmp/dotfiles
source ~/.bashrc
clear
```

## ScreenShots
##### Bash
![Bash](https://raw.githubusercontent.com/casjay-dotfiles/minimal/master/screenshots/term-bash.png "Bash Shell")
##### Fish
![Fish](https://raw.githubusercontent.com/casjay-dotfiles/minimal/master/screenshots/term-fish.png "Fish Shell")
##### ZSH
![zsh](https://raw.githubusercontent.com/casjay-dotfiles/minimal/master/screenshots/term-zsh.png "ZSH Shell")
##### TMUX
![TMUX](https://raw.githubusercontent.com/casjay-dotfiles/minimal/master/screenshots/term-tmux.png "TMUX")
##### SCREEN
![Screen](https://raw.githubusercontent.com/casjay-dotfiles/minimal/master/screenshots/term-screen.png "Screen")

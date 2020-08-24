#!/usr/bin/env bash

SCRIPTNAME="$(basename $0)"
SCRIPTDIR="$(dirname "${BASH_SOURCE[0]}")"
HOME="${USER_HOME:-${HOME}}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author          : Jason
# @Contact         : casjaysdev@casjay.net
# @File            : install
# @Created         : Wed, Aug 09, 2020, 02:00 EST
# @License         : WTFPL
# @Copyright       : Copyright (c) CasjaysDev
# @Description     : installer script for minimal
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set functions

SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/casjay-dotfiles/scripts/raw/master/functions}"
SCRIPTSFUNCTDIR="${SCRIPTSAPPFUNCTDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-system-installer.bash}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -f "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE" ]; then
   . "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE"
elif [ -f "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE" ]; then
   . "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE"
else
   curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
   . "/tmp/$SCRIPTSFUNCTFILE"
fi

##################################################################################################
# Additional Deps
# Debian/Ubuntu - apt install python3-pip python-dev libjpeg-dev libfreetype6 libfreetype6-dev zlib1g-dev
# CentOS/Fedora - yum install python-devel libjpeg-devel python3-pip
__env() {
   PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/local/sbin:/usr/sbin:/sbin"
   #Modify and set if using the auth token
   #AUTHTOKEN="${GITHUB_ACCESS_TOKEN}"
   # either http https or git
   GITPROTO="https://"
   #Your git repo
   GITREPO="github.com/casjay-dotfiles/minimal"
   #scripts repo
   SCRIPTSREPO="https://github.com/casjay-dotfiles/scripts"
   # Git Command - Private Repo
   #GITURL="$GITPROTO$AUTHTOKEN:x-oauth-basic@$GITREPO"
   #Public Repo
   GITURL="$GITPROTO$GITREPO"
   # Default NTP Server
   NTPSERVER="ntp.casjay.net"
   # Default dotfiles dir
   # Set primary dir
   DOTFILES="$HOME/.local/dotfiles/minimal"
   # Set the temp directory
   DOTTEMP="/tmp/dotfiles-minimal-$USER"
   # Set tmpfile
   TMP_FILE="$(mktemp /tmp/dfm-XXXXXXXXX)"
}
__env

##################################################################################################
clear
sleep 1
printf "\n\n\n\n\n\t\t ${GREEN} *** Initializing the installer please wait *** ${NC} \n "
sleep 2
##################################################################################################

if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
   if sudo bash -c '[ ! -f "/etc/sudoers.d/insults" ]'; then
      echo "Defaults    insults" >"/tmp/sudo_insults"
      sudo chown -f root:root "/tmp/sudo_insults" 2>/dev/null
      sudo mv -f "/tmp/sudo_insults" "/etc/sudoers.d/insults" 2>/dev/null
   fi
fi

##################################################################################################

if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
   MYUSER=${SUDO_USER:-$(whoami)}
   ISINDSUDO=$(sudo grep -Re "$MYUSER" /etc/sudoers* | grep "ALL" >/dev/null)
   if sudo bash -c ' [ ! -f "/etc/sudoers.d/$MYUSER" ]'; then
      echo "$MYUSER ALL=(ALL)   NOPASSWD: ALL" >"/tmp/sudo_$MYUSER"
      sudo chown -f root:root "/tmp/sudo_$MYUSER" 2>/dev/null
      sudo chmod -f 440 "/tmp/sudo_$MYUSER" 2>/dev/null
      sudo mv -f "/tmp/sudo_$MYUSER" "/etc/sudoers.d/$MYUSER" 2>/dev/null
   fi
   unset -f "MYUSER" "ISINDSUDO" 2>/dev/null
fi

##################################################################################################

# Setup functions

# Lets check for required programs
__requiredpkgs() {
   GIT="$(command -v git 2>/dev/null)"
   CURL="$(command -v curl 2>/dev/null)"
   WGET="$(command -v wget 2>/dev/null)"
   VIM="$(command -v vim 2>/dev/null)"
   NVIM="$(command -v nvim 2>/dev/null)"
   TMUX="$(command -v tmux 2>/dev/null)"
   ZSH="$(command -v zsh 2>/dev/null)"
   FISH="$(command -v fish 2>/dev/null)"
   SUDO="$(command -v sudo 2>/dev/null)"
   NEOFETCH="$(command -v neofetch 2>/dev/null)"
   GPG="$(command -v gpg 2>/dev/null)"
   NETTOOLS="$(command -v ifconfig 2>/dev/null)"
   LSBR="$(command -v lsb_release 2>/dev/null)"
   POWERLINE="$(command -v powerline-daemon 2>/dev/null)"
   HTOP="$(command -v htop 2>/dev/null)"
   LSOF="$(command -v lsof 2>/dev/null)"
   HG="$(command -v hg 2>/dev/null)"
   BZR="$(command -v bzr 2>/dev/null)"
   STRACE="$(command -v strace 2>/dev/null)"
   COWSAY="$(command -v cowsay 2>/dev/null)"
   TF="$(command -v thefuck 2>/dev/null)"
   SCREEN="$(command -v screen 2>/dev/null)"
   SVN="$(command -v svn 2>/dev/null)"
#   CMUS="$(command -v cmus 2>/dev/null)"
   PYPIP="$(command -v $PIP 2>/dev/null)"
   SENDXMPP="$(command -v sendxmpp 2>/dev/null)"
   XTERM="$(command -v xterm 2>/dev/null)"
   FORTUNE="$(command -v fortune 2>/dev/null)"
   FIGLET="$(command -v figlet 2>/dev/null)"
   DENV="$(command -v direnv 2>/dev/null)"
   VIFM="$(command -v vifm 2>/dev/null)"
   NEOMUTT="$(command -v neomutt 2>/dev/null)"

}

##################################################################################################

__missingpkg() {
   unset MISSING
   if [[ ! "$GIT" ]]; then MISSING+="git "; fi
   if [[ ! "$CURL" ]]; then MISSING+="curl "; fi
   if [[ ! "$WGET" ]]; then MISSING+="wget "; fi
   if [[ ! "$VIM" ]]; then MISSING+="vim "; fi
   if [[ ! "$NVIM" ]]; then MISSING+="neovim "; fi
   if [[ ! "$TMUX" ]]; then MISSING+="tmux "; fi
   if [[ ! "$ZSH" ]]; then MISSING+="zsh "; fi
   if [[ ! "$FISH" ]]; then MISSING+="fish "; fi
   if [[ ! "$SUDO" ]]; then MISSING+="sudo "; fi
   if [[ ! "$NEOFETCH" ]]; then MISSING+="neofetch "; fi
   if [[ ! "$GPG" ]]; then MISSING+="gnupg "; fi
   if [[ ! "$NETTOOLS" ]]; then MISSING+="net-tools "; fi
   if [[ ! "$LSBR" ]]; then MISSING+="$LSBPAC "; fi
   if [[ ! "$POWERLINE" ]]; then MISSING+="powerline "; fi
   if [[ ! "$HTOP" ]]; then MISSING+="htop "; fi
   if [[ ! "$LSOF" ]]; then MISSING+="lsof "; fi
   if [[ ! "$HG" ]]; then MISSING+="mercurial "; fi
   if [[ ! "$BZR" ]]; then MISSING+="bzr "; fi
   if [[ ! "$STRACE" ]]; then MISSING+="strace "; fi
   if [[ ! "$COWSAY" ]]; then MISSING+="cowsay "; fi
   if [[ ! "$TF" ]]; then MISSING+="thefuck "; fi
   if [[ ! "$SCREEN" ]]; then MISSING+="screen "; fi
   if [[ ! "$SVN" ]]; then MISSING+="subversion "; fi
#   if [[ ! "$CMUS" ]]; then MISSING+="cmus "; fi
   if [[ ! "$PYPIP" ]]; then MISSING+="$PYTHONVER-pip "; fi
   if [[ ! "$SENDXMPP" ]]; then MISSING+="sendxmpp "; fi
   if [[ ! "$XTERM" ]]; then MISSING+="xterm "; fi
   if [[ ! "$FORTUNE" ]]; then MISSING+="fortune-mod fortunes-off fortunes "; fi
   if [[ ! "$FIGLET" ]]; then MISSING+="figlet "; fi
   if [[ ! "$DENV" ]]; then MISSING+="direnv "; fi
   if [[ ! "$VIFM" ]]; then MISSING+="vifm "; fi
   if [[ ! "$NEOMUTT" ]]; then MISSING+="neomutt "; fi

}

##################################################################################################

# Remove previous installs
#for d in completions profile ; do rm -Rf "$HOME/.config/bash/$d" ; done
if [ ! -d "$DOTFILES"/.git ]; then rm -Rf "$DOTFILES" >/dev/null 2>&1; fi
rm -Rf "$DOTTEMP" >/dev/null 2>&1

##################################################################################################

# fixes

##################################################################################################

if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
   # Define the package manager and install option
   # Ubuntu/Debian
   if [ -f /usr/local/bin/apt-get ]; then
      APTOPTS="-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold""
      APTINST="--ignore-missing -yy -qq --allow-unauthenticated --assume-yes"
      pkgmgr="sudo DEBIAN_FRONTEND=noninteractive apt-get $APTOPTS"
      instoption="install $APTINST"
      upgroption="upgrade $APTINST"
      instupdateoption="$pkgmgr $upgroption"
      pkgmgrman="sudo apt-get install"
      pkgmgrmanup="sudo apt-get upgrade"
      LSBPAC="lsb-release"
      TORUSER="=debian-tor"
      CRONUPDATE="5 4 * * * root apt-get update >/dev/null 2>&1 ; $instupdateoption >/dev/null 2>&1"

      ##################################################################################################
      printf "\n\t\t ${BLUE} *** Initializing the system time *** ${NC} \n "
      ##################################################################################################
      if [ -f "$(command -v chronyd 2>/dev/null)" ]; then
         sudo chronyd -q "server pool.ntp.org iburst" >/dev/null 2>&1
      elif [ ! -f "$(command -v ntpd 2>/dev/null)" ]; then
         sudo "$pkgmgr" "$instoption" ntp ntpdate -yy -qq >/dev/null 2>&1
         sudo ntpdate "$NTPSERVER" >/dev/null 2>&1
      fi

      ##################################################################################################
      printf "\n\t\t ${BLUE} *** Update Check *** ${NC} \n "
      ##################################################################################################
      instchkupdatecmd="$(sudo apt-get update >/dev/null && apt-get --just-print upgrade | grep "Inst " | wc -l)"

      # Ubuntu/Debian
   elif [ -f /usr/bin/apt-get ]; then
      APTOPTS="-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold""
      APTINST="--ignore-missing -yy -qq --allow-unauthenticated --assume-yes"
      pkgmgr="DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get $APTOPTS"
      instoption="install $APTINST"
      upgroption="upgrade $APTINST"
      instupdateoption="$pkgmgr $upgroption"
      pkgmgrman="/usr/bin/apt-get install"
      pkgmgrmanup="/usr/bin/apt-get upgrade"
      LSBPAC="lsb-release"
      TORUSER="debian-tor"
      CRONUPDATE="5 4 * * * root /usr/bin/apt-get update >/dev/null 2>&1 ; $instupdateoption >/dev/null 2>&1"

      ##################################################################################################
      printf "\n\t\t ${BLUE} *** Initializing the system time *** ${NC} \n "
      ##################################################################################################
      if [ -f "$(command -v chronyd 2>/dev/null)" ]; then
         sudo chronyd -q "server pool.ntp.org iburst" >/dev/null 2>&1
      elif [ ! -f "$(command -v ntpd 2>/dev/null)" ]; then
         sudo "$pkgmgr" "$instoption" ntp ntpdate -yy -qq >/dev/null 2>&1
         sudo ntpdate "$NTPSERVER" >/dev/null 2>&1
      fi
      ##################################################################################################
      printf "\n\t\t ${BLUE} *** Update Check *** ${NC} \n "
      ##################################################################################################
      instchkupdatecmd="$(sudo apt-get update >/dev/null && apt-get --just-print upgrade | grep "Inst " | wc -l)"

      # Redhat/Fedora
   elif [ -f /usr/bin/dnf ]; then
      pkgmgr="/usr/bin/dnf"
      instoption="install -y -q --skip-broken"
      instupdateoption="/usr/bin/dnf update -y -q --skip-broken"
      pkgmgrman="/usr/bin/dnf install"
      pkgmgrmanup="/usr/bin/dnf update"
      LSBPAC="redhat-lsb"
      TORUSER="toranon"
      CRONUPDATE="5 4 * * * root /usr/bin/dnf makecache >/dev/null 2>&1 ; $instupdateoption >/dev/null 2>&1"

      ##################################################################################################
      printf "\n\t\t ${BLUE} *** Initializing the system time *** ${NC} \n "
      ##################################################################################################
      if [ -f "$(command -v chronyd 2>/dev/null)" ]; then
         sudo chronyd -q "server pool.ntp.org iburst" >/dev/null 2>&1
      elif [ ! -f "$(command -v ntpd 2>/dev/null)" ]; then
         sudo "$pkgmgr" "$instoption" ntp ntpdate -yy -qq >/dev/null 2>&1
         sudo ntpdate "$NTPSERVER" >/dev/null 2>&1
      fi
      ##################################################################################################
      printf "\n\t\t ${BLUE} *** Update Check *** ${NC} \n "
      ##################################################################################################
      instchkupdatecmd="$(sudo dnf check-update -q | grep -Ev "Security|duplicate" | wc -l)"

      # Redhat/Fedora
   elif [ -f /usr/bin/yum ]; then
      pkgmgr="/usr/bin/yum"
      instoption="install -y -q"
      instupdateoption="/usr/bin/yum update -y -q --skip-broken"
      pkgmgrman="/usr/bin/yum install"
      pkgmgrmanup="/usr/bin/yum update"
      LSBPAC="redhat-lsb"
      TORUSER="toranon"
      CRONUPDATE="5 4 * * * root /usr/bin/yum makecache >/dev/null 2>&1 ;$instupdateoption >/dev/null 2>&1"

      ##################################################################################################
      printf "\n\t\t ${BLUE} *** Initializing the system time *** ${NC} \n "
      ##################################################################################################
      if [ -f "$(command -v chronyd 2>/dev/null)" ]; then
         sudo chronyd -q "server pool.ntp.org iburst" >/dev/null 2>&1
      elif [ ! -f "$(command -v ntpd 2>/dev/null)" ]; then
         sudo "$pkgmgr" "$instoption" ntp ntpdate -yy -qq >/dev/null 2>&1
         sudo ntpdate "$NTPSERVER" >/dev/null 2>&1
      fi
      ##################################################################################################
      printf "\n\t\t ${BLUE} *** Update Check *** ${NC} \n "
      ##################################################################################################
      instchkupdatecmd="$(sudo yum check-update -q | grep -Ev "Security|duplicate" | wc -l)"

      # ArchLinux
   elif [ -f /usr/bin/pacman ]; then
      pkgmgr="/usr/bin/pacman"
      instoption="-Syy --needed --noconfirm"
      instupdateoption="/usr/bin/pacman -Syyu --noconfirm"
      pkgmgrman="/usr/bin/pacman -S"
      pkgmgrmanup="/usr/bin/pacman -Syyu"
      LSBPAC="lsb-release"
      TORUSER="tor"
      CRONUPDATE="5 4 * * * root /usr/bin/pacman -Syy >/dev/null 2>&1 ; $instupdateoption >/dev/null 2>&1"

      ##################################################################################################
      printf "\n\t\t ${BLUE} *** Initializing the system time *** ${NC} \n "
      ##################################################################################################
      if [ -f "$(command -v chronyd 2>/dev/null)" ]; then
         sudo chronyd -q "server pool.ntp.org iburst" >/dev/null 2>&1
      elif [ ! -f "$(command -v ntpd 2>/dev/null)" ]; then
         sudo "$pkgmgr" "$instoption" ntp ntpdate -yy -qq >/dev/null 2>&1
         sudo ntpdate "$NTPSERVER" >/dev/null 2>&1
      fi
      ##################################################################################################
      printf "\n\t\t ${BLUE} *** Update Check *** ${NC} \n "
      ##################################################################################################
      instchkupdatecmd="$(checkupdates 2>/dev/null | wc -l)"

      # Execute update check
      if [[ "$instchkupdatecmd" != 0 ]]; then
         ##################################################################################################
         printf "\n\t\t ${RED} *** You have $instchkupdatecmd update available ***${NC}\n"
         printf "\t\t ${PURPLE} *** Attemping to update your system ***${NC}\n"
         sudo $instupdateoption >/dev/null 2>&1
         RETVAL=$?
         if [ "$RETVAL" -ne 0 ]; then
            printf "\t\t ${RED} *** Update has failed exit code was: $RETVAL - Please do a manual update ***${NC}\n"
            printf "\t\t ${GREEN} *** sudo $pkgmgrmanup ***${NC}\n"
         else
            printf "\t\t ${GREEN} *** Update completed successfully ***${NC}\n"
         fi
      fi
   fi
fi

##################################################################################################

##################################################################################################
printf "\n\t\t ${BLUE} *** Checking for required packages *** ${NC} \n "
##################################################################################################

__requiredpkgs
__missingpkg

if [ -z "$DENV" ] || [ -z "$FORTUNE" ] || [ -z "$FIGLET" ] || [ -z "$NETTOOLS" ] || [ -z "$VIFM" ] || [ -z "$NEOMUTT" ] ||
   [ -z "$XTERM" ] || [ -z "$SENDXMPP" ] || [ -z "$PYPIP" ] || [ -z "$CMUS" ] || [ -z "$SVN" ] ||
   [ -z "$SCREEN" ] || [ -z "$TF" ] || [ -z "$POWERLINE" ] || [ -z "$HTOP" ] || [ -z "$LSOF" ] ||
   [ -z "$HG" ] || [ -z "$BZR" ] || [ -z "$STRACE" ] || [ -z "$COWSAY" ] || [ -z "$LSBR" ] || [ -z "$GIT" ] ||
   [ -z "$CURL" ] || [ -z "$WGET" ] || [ -z "$VIM" ] || [ -z "$VIM" ] || [ -z "$TMUX" ] || [ -z "$ZSH" ] ||
   [ -z "$FISH" ] || [ -z "$SUDO" ] || [ -z "$NEOFETCH" ] || [ -z "$GPG" ]; then

   ##################################################################################################
   printf "\t\t ${RED} *** • The following are needed: • ***${NC}\n"
   printf "\t\t ${RED} *** • ${MISSING} • ***${NC}\n"
   printf "\t\t ${PURPLE} *** • Attempting to install the missing package[s] • ***${NC}\n"
   ##################################################################################################
   if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
      for MISSINGPKG in ${MISSING}; do
         sudo $pkgmgr $instoption ${MISSINGPKG} >/dev/null 2>&1
      done

      __requiredpkgs
      __missingpkg

      if [ -n "$MISSING" ]; then
         printf "\t\t ${RED} *** • Install failed please install the packages manually • ***${NC}\n"
         printf "\t\t ${GREEN} *** • $pkgmgrman ${MISSING} • ***${NC}\\n"
         sleep 5
      else
         printf "\t\t ${GREEN} *** Packages install completed successfully ***${NC}\n"
      fi
   else
      ##################################################################################################
      printf "\t\t ${RED} *** • I can't get root access You will have to manually install the missing programs • ***${NC}\n"
      printf "\t\t ${RED} *** • ${MISSING} • ***${NC}\n\n\n"
      ##################################################################################################
      exit
   fi
fi

##################################################################################################
printf "\n\t\t ${BLUE} *** Setting up the git repo *** ${NC} \n "
##################################################################################################

find "$HOME" -xtype l -delete >/dev/null 2>&1
mkdir -p "$HOME"/.ssh "$HOME"/.gnupg >/dev/null 2>&1

if [ -d "$DOTFILES"/.git ]; then
   cd "$DOTFILES" && git pull --recurse-submodules -fq >/dev/null 2>&1
   getexitcode "git successfully updated"
else
   git clone --recursive -q "$GITURL" "$DOTFILES" >/dev/null 2>&1
   getexitcode "git successfully cloned"
fi

##################################################################################################
printf "\n\t\t ${BLUE} *** The installer is updating the scripts *** ${NC} \n "
##################################################################################################
# Update remote

sudo bash -c "$(curl -LSs https://github.com/casjay-dotfiles/scripts/raw/master/install.sh)"

######################################

for config in bash dircolors fish git htop tig tmux vifm vim zsh; do
   bash -c "$(curl -LSs https://github.com/casjay-dotfiles/$config/raw/master/install.sh)"
done

######################################

if [ -d "$DOTFILES" ]; then cp -Rf "$DOTFILES" "$DOTTEMP" >/dev/null 2>&1; fi

##################################################################################################
printf "\n\t\t ${BLUE} *** Installing your dotfiles *** ${NC} \n "
##################################################################################################
# fix hostname and ip
find "$DOTTEMP"/etc -type f -exec sed -i "s#MYHOSTIP#$CURRIP4#g" {} \; >/dev/null 2>&1
find "$DOTTEMP"/etc -type f -exec sed -i "s#MYHOSTNAME#$(hostname -s)#g" {} \; >/dev/null 2>&1
find "$DOTTEMP"/usr -type f -exec sed -i "s#MYHOSTIP#$CURRIP4#g" {} \; >/dev/null 2>&1
find "$DOTTEMP"/usr -type f -exec sed -i "s#MYHOSTNAME#$(hostname -s)#g" {} \; >/dev/null 2>&1

# Fix permissions
chmod -Rf 755 "$DOTTEMP"/usr/local/bin/* >/dev/null 2>&1
chmod -Rf 755 "$DOTTEMP"/etc/skel/.local/bin/* >/dev/null 2>&1
chmod -Rf 755 "$DOTTEMP"/etc/skel/.local/share/scripts/* >/dev/null 2>&1

find "$DOTTEMP"/etc -type f -iname "*.bash" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
find "$DOTTEMP"/etc -type f -iname "*.sh" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
find "$DOTTEMP"/etc -type f -iname "*.pl" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
find "$DOTTEMP"/etc -type f -iname "*.cgi" -exec chmod 755 -Rf {} \; >/dev/null 2>&1

find "$DOTTEMP"/usr -type f -iname "*.bash" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
find "$DOTTEMP"/usr -type f -iname "*.sh" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
find "$DOTTEMP"/usr -type f -iname "*.pl" -exec chmod 755 -Rf {} \; >/dev/null 2>&1
find "$DOTTEMP"/usr -type f -iname "*.cgi" -exec chmod 755 -Rf {} \; >/dev/null 2>&1

unalias cp 2>/dev/null

rm -Rf "$DOTTEMP"/etc/skel/.config/bash/profile/*.win >/dev/null 2>&1

cp -Rfa "$DOTTEMP"/etc/skel/. "$HOME"/ >/dev/null 2>&1

# Needed for gpg
GPG_TTY="$(tty)" >/dev/null 2>&1

# Set correct Permissions
find "$HOME"/.gnupg "$HOME"/.ssh -type f -exec chmod 600 {} \; >/dev/null 2>&1
find "$HOME"/.gnupg "$HOME"/.ssh -type d -exec chmod 700 {} \; >/dev/null 2>&1
chmod 755 -f "$HOME" >/dev/null 2>&1

if [ ! -f "$HOME"/.dircolors ]; then ln -sf "$HOME"/.config/dircolors/default "$HOME"/.dircolors; fi

# Install system files
if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
   ##################################################################################################
   printf "\n\t\t ${BLUE} *** The installer is installing system wide *** ${NC} \n "
   ##################################################################################################

   if [ -d "$DOTTEMP/etc" ]; then sudo cp -Rfa "$DOTTEMP/etc/." /etc/; fi
   if [ -d "$DOTTEMP/usr" ]; then sudo cp -Rfa "$DOTTEMP/usr/." /usr/; fi
   if [ -d "$DOTTEMP/var" ]; then sudo cp -Rfa "$DOTTEMP/var/." /var/; fi
   if [ -f "$DOTTEMP/version.txt" ]; then cp -Rf "$DOTTEMP/version.txt" /etc/casjaysdev/updates/versions/configs.txt; fi


fi

# Apply any patches
##################################################################################################
printf "\n\t\t ${BLUE} *** The installer is applying patches *** ${NC} \n "
##################################################################################################
if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
   bash -c "./patches/apply-patches.sh >/dev/null 2>&1"
fi
##################################################################################################

# Finalizing
##################################################################################################
printf "\n\t\t ${BLUE} *** The installer is running post install commands *** ${NC} \n "
##################################################################################################
fc-cache -f >/dev/null 2>&1

mkdir -p "$HOME"/{Projects,Music,Videos,Downloads,Pictures,Documents}

# Import gpg keys
gpg --import "$DOTTEMP"/tmp/*.gpg 2>/dev/null
gpg --import "$DOTTEMP"/tmp/*.sec 2>/dev/null
gpg --import-ownertrust "$DOTTEMP"/tmp/ownertrust.gpg 2>/dev/null

rm -Rf "$DOTTEMP"
rm -Rf "$TMP_FILE"

find "$HOME" -xtype l -delete >/dev/null 2>&1

##################################################################################################

source "$HOME/.bashrc"

##################################################################################################
printf "\n\t\t ${GREEN} *** The installer has finished *** ${NC} \n\n "
printf "\t\t ${RED} *** For the configurations to take effect *** ${NC} \n "
printf "\t\t ${RED} *** you should logout or restart your system *** ${NC} \n\n "
##################################################################################################

unset __requiredpkgs __missingpkg __getip __getpythonver __env sudoreq >/dev/null 2>&1

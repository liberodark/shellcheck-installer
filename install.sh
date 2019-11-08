#!/bin/bash
#
# About: Install ShellCheck automatically
# Author: liberodark
# License: GNU GPLv3

version="0.0.1"

echo "Welcome on ShellCheck Install Script $version"

#=================================================
# CHECK ROOT
#=================================================

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST AND VAR
#=================================================

distribution=$(cat /etc/*release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')


install_shellcheck(){
      scversion="stable" # or "v0.4.7", or "latest"
      wget -qO- "https://storage.googleapis.com/shellcheck/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJv
      cp "shellcheck-${scversion}/shellcheck" /usr/bin/
      shellcheck --version
      rm -r shellcheck-stable*
      }


check_shellcheck(){
echo "Install ShellCheck ($distribution)"

  # Check OS & shellcheck

  if ! command -v shellcheck &> /dev/null; then

    if [[ "$distribution" = CentOS || "$distribution" = CentOS || "$distribution" = Red\ Hat || "$distribution" = Suse || "$distribution" = Oracle ]]; then
      yum install -y xz &> /dev/null

      install_shellcheck || exit
      
    elif [[ "$distribution" = Fedora ]]; then
      dnf install -y xz &> /dev/null
    
      install_shellcheck || exit
    
    elif [[ "$distribution" = Debian || "$distribution" = Ubuntu || "$distribution" = Deepin ]]; then
      apt-get update &> /dev/null
      apt-get install -y xz-utils --force-yes &> /dev/null
    
      install_shellcheck || exit
      
    elif [[ "$distribution" = Manjaro || "$distribution" = Arch\ Linux ]]; then
      pacman -S xz --noconfirm &> /dev/null
    
      install_shellcheck || exit

    fi
fi
}

check_shellcheck

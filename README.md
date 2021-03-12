# Tmur
It is a command line tool to help you manage your **iptables** rules of the Linux kernel firewall. 
It allows switching between ready-made iptables rulesets.

Please do not confuse with the successor of iptables --> nftables.
This software does not support nftables.
So, before using this software, check first what your system using by default.


## Release
       Name: Firewall TMur
       Version:  1 Beta
       License: GNU GPL v3  https://www.gnu.org/licenses/gpl-3.0.en.html

## Tested on operating systems:

* Debian
* Linux Mint
* PCLinuxOS
* Uplos Linux
* ManjaroLinux

I do not guarantee that the program will always run properly on all systems. 
Operating systems have minor differences that I tried to include in **/lib/system.settings.lib.sh**
If you want to use this tool and not working, 
* report bugs, **<https://github.com/tele1/Tmur/issues>**
* support development.


## Dependencies for tmur:
	bash
	iptables
    coreutils
    net-tools (netstat)

## Recommended dependencies 
    nmap


## How to use

Download, unpack and you can use.

```
bash tmur --help
```

At the moment I do not have an installation script.


## Useful links for tools:
- Iptables:    <https://netfilter.org/documentation/>
- Bash:    <http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html>

Example tool for creating graphical user interfaces (GUI) for bash script
- GtkDialog examples:    <http://xpt.sourceforge.net/techdocs/language/gtkdialog/gtkde02-GtkdialogExamples/single/>
- GtkDialog tutorial:    <http://murga-linux.com/puppy/viewtopic.php?p=274035#274035>
- GtkDialog Reference:    <https://github.com/01micko/gtkdialog/blob/wiki/ProjectHome.md>


## Writing on GitHub For Documents
* <https://help.github.com/en/categories/writing-on-github>
* Especially <https://guides.github.com/features/mastering-markdown/#what>

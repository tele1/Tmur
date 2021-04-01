

## 1. Sources.
* The init part comes from the Debian Linux repository. Iptables-persistent /usr/share/netfilter-persistent/plugins.d/
* Part of the systemd comes from the Arch Linux repository. https://github.com/archlinux/svntogit-packages/blob/packages/iptables/trunk/iptables.service


## 2. About iptables service.  
The system boots without iptables rules.  
Service manager like "init" or "systemd" is used for restore iptables rules after reboot.  
The service contains the path from where to restore the rules.  
Package iptables-persistent provide service.  
Instead of this we can also put script in  /etc/network/if-pre-up.d  or  /etc/network/interfaces  
Useful links:  
2.1. https://help.ubuntu.com/community/IptablesHowTo#Configuration_on_startup  
2.2. https://askubuntu.com/questions/218/command-to-list-services-that-start-on-startup  
2.3. https://wiki.gentoo.org/wiki/OpenRC

Example: File:   /etc/network/if-pre-up.d/iptables
```
#!/bin/sh
/usr/sbin/iptables-restore < /etc/iptables/rules.v4
/usr/sbin/ip6tables-restore < /etc/iptables/rules.v6
```
```
chmod 510 /etc/network/if-pre-up.d/iptables
```
Errors are logged automatically by the system for this file.  
To check log if firewall not was restored you can use command in terminal:  grep "/etc/network/if-pre-up.d/iptables" /var/log/syslog  
  
  
## 3. Observations.

3.1 Flush command resets the firewall settings.
So this should be firewall job and not system service.
But it looks like trying to combine all the iptables commands into one .
It would make more sense if this service were just to turn the firewall on and off.
If you build something similar upgrade app and leave services.

I will try to explain otherwise.
This service is considered to be a service for loading and cleaning iptables rules.
But its main task is to restore settings at system startup. That is all and nothing else.
This is a contradiction.

" iptables-restore " command is specific. Loads settings from file and exits.
So it only works for a moment but systemctl show that this app running, but this is not true.
So I can not use ExecStop to kill a process which isn't exist.
Other services like ssh server, rsync server still running.
I can remove line ExecStop=... from own service but after reboot I see from systemctl again.
I can not put this command to cron because because this command for security reasons must be run before internet can be started.
So it must be started in a specific order like the service although it is not running permanently.

That's why I think that this service is badly written, but the result is that what should be.  


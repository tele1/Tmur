The init part comes from the Debian Linux repository.
Part of the systemd comes from the Arch Linux repository.


    #### Detect system service manager #####
    #   Service manager like "init" or "systemd" is used for restore iptables rules after reboot.
    #   The service contains the path from where to restore the rules.
    #   Instead of a service can be used also: iptables-persistent package, /etc/network/if-pre-up.d , /etc/network/interfaces 
    #   useful links:
    #   1. https://help.ubuntu.com/community/IptablesHowTo#Configuration_on_startup
    #   2. https://askubuntu.com/questions/218/command-to-list-services-that-start-on-startup
    #   3. https://wiki.gentoo.org/wiki/OpenRC



    # List all services:
    # init:         service --status-all
    # systemd:      systemctl --type=service
    # Probably iptables running from ufw service


Example: 
==============================={
File:   /etc/network/if-pre-up.d/iptables
===============
#!/bin/sh
/usr/sbin/iptables-restore < /etc/iptables/rules.v4
/usr/sbin/ip6tables-restore < /etc/iptables/rules.v6
===============

	chmod 510 /etc/network/if-pre-up.d/iptables

    ## Errors are logged automatically by the system for this file.
    ## To check log if firewall not was restored you can use command in terminal:  grep "/etc/network/if-pre-up.d/iptables" /var/log/syslog 
===============================}

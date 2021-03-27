#!/bin/bash


##########################################################################################################
#-----------------------------------------------------{
LINUX_DISTRIBUTION=$(lsb_release -is)

# Set path for bin
case "$LINUX_DISTRIBUTION" in
"Debian")
	PATH_BIN=""
	# test if package is installed
	#if [[ $(dpkg-query -W ${PATH_BIN}iptables-persistent | awk '{print $1}') != ${PATH_BIN}iptables-persistent ]] ; then
	#	echo "======================"
	#	echo " > Hello from Debian! :D"
	#	echo " > Exist two ways save rules https://wiki.debian.org/iptables  "
	#	echo " > second way is \" iptables-persistent \" installed."
	#	echo "======================"
	#fi
	system_iptables_save() {
	cat <<EOF > /etc/network/if-pre-up.d/iptables
#!/bin/sh
/sbin/iptables-restore < /etc/iptables/rules.v4
/sbin/ip6tables-restore < /etc/iptables/rules.v6
EOF
	chmod 510 /etc/network/if-pre-up.d/iptables
	}	
	;;
"Linuxmint")
    # Wiki:     https://help.ubuntu.com/community/IptablesHowTo
    # List all services:
    #       service --status-all
    #       systemctl --type=service
    # Probably iptables running from ufw service
	PATH_BIN=""
	system_iptables_save() {
	cat <<EOF > /etc/network/if-pre-up.d/iptables
#!/bin/sh
/usr/sbin/iptables-restore < /etc/iptables/rules.v4
/usr/sbin/ip6tables-restore < /etc/iptables/rules.v6
EOF
	chmod 510 /etc/network/if-pre-up.d/iptables
    ## Errors are logged automatically by the system for this file.
    ## To check log if firewall not was restored you can use command in terminal:  grep "/etc/network/if-pre-up.d/iptables" /var/log/syslog 
	}
    ;;
"ManjaroLinux")
	PATH_BIN=""
	echo "======================"
	echo " > Hello from ManjaroLinux! :D"
	echo " > Read this: https://wiki.manjaro.org/index.php?title=iptables "
	echo " > because firewall don't have iptables.service for systemd. Exiting ..."
	exit 1					;;
"PCLinuxOS")
	PATH_BIN="/sbin/"  
	system_iptables_save() {
	${PATH_BIN}service iptables save
	}						;;
"Solus")
	PATH_BIN="/sbin/" 
	echo "======================"
	echo " > Hello Solus! :D"
	echo " > Read this: https://discuss.getsol.us/d/6530-configure-iptables "
	echo " > because your distribution is not properly configured "
	echo " > I mean it don't have iptables.service for systemd. Exiting ..."
	exit 1					;;
    ;;
"UPLOS")
	PATH_BIN="/sbin/"    	
	system_iptables_save() {
	${PATH_BIN}service iptables save
	}						;;

*)
	PATH_BIN=""
	echo "======================"
	echo "--> Error: I'm sorry, but the program is not supported by your Linux distribution,"
	echo "	no one has asked for help."
	echo "Exiting ..."
	exit 1					;;

	## check for init and use or remove it lines
	#if [ ! -e /etc/init.d/iptables ] ; then
		#
		#echo " > We will create service for systemd"
		#touch /etc/init.d/iptables
		#echo -e '#!/bin/bash\niptables-restore < /etc/sysconfig/iptables' > /etc/init.d/iptables
		#chmod +x /etc/init.d/iptables
		#update-rc.d firewall defaults 90
		#echo " > Service created."
	#fi
esac
#-----------------------------------------------------}


##########################################################################################################



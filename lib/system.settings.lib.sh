#!/bin/bash


##########################################################################################################
#-----------------------------------------------------{
LINUX_DISTRIBUTION=$(lsb_release -is)


PRINT_ERROR_NOT_SUPPORTED() {
    echo "======================"
    echo "--> Error: $1 not found or you have not installed."
    echo "	Ask developers your linux distributionfor to get help and better support."
    echo "  And write also there  https://github.com/tele1/Tmur/issues "
    echo "Exiting."
    exit 1
}


DETECT_SYSTEM_SERVICE_MANAGER() {
######### Detect system service manager #####{
    #   Service manager like "init" or "systemd" is used for restore iptables rules after reboot or for other jobs.
    #   The service contains the path from where to restore the rules.
    #   Instead of a service can be used also: iptables-persistent package, /etc/network/if-pre-up.d , /etc/network/interfaces 
    #   useful links:
    #   1. https://help.ubuntu.com/community/IptablesHowTo#Configuration_on_startup
    #   2. https://askubuntu.com/questions/218/command-to-list-services-that-start-on-startup
    #   3. https://wiki.gentoo.org/wiki/OpenRC
    INIT_PATH=$(readlink -f "$(which init)")
    SYSTEMD_PATH=$(readlink -f "$(which systemd)")
    OPENRC_PATH=$(readlink -f "$(which openrc)")

    TMUR_SAVE() {
            umask 177
            mkdir -p /etc/iptables
	        echo "$ADD_LIST_v4" > /etc/iptables/firewall.list.rules.v4
	        echo "$ADD_LIST_v6" > /etc/iptables/firewall.list.rules.v6
    }

    # Grep will avoid symlink to other system service manager, for example init to systemd
    if echo "$INIT_PATH" | grep -q init ; then
        # Output of command "service --status-all" can be different for linux distributions, so I can not check if service running or not.
        # SYSTEM_SERVICE_MANAGER="init"
        save() {
	        ${PATH_BIN}service iptables  save
	        ${PATH_BIN}service ip6tables save
            TMUR_SAVE
        }	
    elif echo "$SYSTEMD_PATH" | grep -q systemd ; then
        # SYSTEM_SERVICE_MANAGER="systemd"
        save() {
	        PATH_TO_RULES=$(systemctl cat iptables.service | grep ExecStart | awk '{ print $2 }')
            ${PATH_BIN}iptables-save  > "$PATH_TO_RULES"
            ${PATH_BIN}ip6tables-save > "$PATH_TO_RULES"
            TMUR_SAVE
        }
    elif echo "$OPENRC_PATH" | grep -q openrc ; then
        # SYSTEM_SERVICE_MANAGER="openrc"
        save() {
	        ${PATH_BIN}rc-service iptables  save
	        ${PATH_BIN}rc-service ip6tables save
            TMUR_SAVE
        }
    else
        PRINT_ERROR_NOT_SUPPORTED "System service manager"
    fi
######### Detect system service manager #####}
}


#   PATH_BIN = Path to iptables binary
#   function save = saves used rules to a file. System service manager loads service iptables file at system startup.
#   Maybe *) will overwrite this manual configuration in future.
case "$LINUX_DISTRIBUTION" in
"Debian")
	PATH_BIN="/usr/sbin/"
        # SYSTEM_SERVICE_MANAGER="systemd"
        save() {
	        PATH_TO_RULES=$(systemctl cat iptables.service | grep ExecStart | awk '{ print $2 }')
            ${PATH_BIN}iptables-save  > "$PATH_TO_RULES"
            ${PATH_BIN}ip6tables-save > "$PATH_TO_RULES"
            TMUR_SAVE
        }
	;;
"Linuxmint")
	PATH_BIN="/usr/sbin/"
        # SYSTEM_SERVICE_MANAGER="systemd"
        save() {
	        PATH_TO_RULES=$(systemctl cat iptables.service | grep ExecStart | awk '{ print $2 }')
            ${PATH_BIN}iptables-save  > "$PATH_TO_RULES"
            ${PATH_BIN}ip6tables-save > "$PATH_TO_RULES"
            TMUR_SAVE
        }
    ;;
"ManjaroLinux")
	PATH_BIN="/usr/bin/"
        # SYSTEM_SERVICE_MANAGER="systemd"
        save() {
	        PATH_TO_RULES=$(systemctl cat iptables.service | grep ExecStart | awk '{ print $2 }')
            ${PATH_BIN}iptables-save  > "$PATH_TO_RULES"
            ${PATH_BIN}ip6tables-save > "$PATH_TO_RULES"
            TMUR_SAVE
        }
    ;;
"PCLinuxOS")
	PATH_BIN="/sbin/"  
        # SYSTEM_SERVICE_MANAGER="init"
        save() {
	        ${PATH_BIN}service iptables  save
	        ${PATH_BIN}service ip6tables save
            TMUR_SAVE
        }
    ;;
"Solus")
	PATH_BIN="/sbin/"
        # SYSTEM_SERVICE_MANAGER="systemd"
        save() {
	        PATH_TO_RULES=$(systemctl cat iptables.service | grep ExecStart | awk '{ print $2 }')
            ${PATH_BIN}iptables-save  > "$PATH_TO_RULES"
            ${PATH_BIN}ip6tables-save > "$PATH_TO_RULES"
            TMUR_SAVE
        }
    ;;
"UPLOS")
	PATH_BIN="/sbin/"  
        # SYSTEM_SERVICE_MANAGER="init"
        save() {
	        ${PATH_BIN}service iptables  save
	        ${PATH_BIN}service ip6tables save
            TMUR_SAVE
        }	
    ;;
*)
	PATH_BIN=$(dirname $(which iptables) |  awk '{ print $1 "/" }')
    if [ ! $(echo "$PATH_BIN" | grep "\S" | wc -l) -eq "1" ] ; then
        PRINT_ERROR_NOT_SUPPORTED "Path to iptables"
    fi
    DETECT_SYSTEM_SERVICE_MANAGER
esac


#-----------------------------------------------------}
##########################################################################################################



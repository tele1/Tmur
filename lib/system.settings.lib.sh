#!/bin/bash


######################################################################################{
## ==== System Settings Library ====
##  Dependencies:   messages.lib.sh


    LINUX_DISTRIBUTION=$(lsb_release -is)

    ##  workaround for stupid system settings:     https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=904988
    if [[ ! ":$PATH:" == *":/sbin:"* ]]; then 
        MESSAGE_WARNING 'Path /sbin not found in $PATH environment variable. ' ; 
        MESSAGE_WARNING 'We will try to temporarily add /sbin /usr/sbin .' ;
        export PATH=$PATH:/sbin:/usr/sbin ; 
    fi

#   PATH_BIN = Path to iptables binary
	PATH_BIN=$(dirname $(which iptables) |  awk '{ print $1 "/" }')
	PATH_BIN_2=$(dirname $(which iptables))
    PATH_IPT_BIN="$PATH_BIN"

    if [ ! $(echo "$PATH_BIN" | grep "\S" | wc -l) -eq "1" ] ; then
        PRINT_ERROR_NOT_SUPPORTED "Path to iptables"
    fi

    if ! echo $PATH | grep -q "$PATH_BIN_2" ; then 
        MESSAGE_WARNING "Path ${PATH_BIN_2} not found in PATH environment variable,"
        MESSAGE_WARNING "so we will export this variable to PATH temporarily." 
        export PATH=${PATH}:${PATH_BIN_2}
    fi

######### Detect system service manager #####{
    #   Service manager like "init" or "systemd" is used for restore iptables rules after reboot or for other jobs.
    #   The service contains the path from where to restore the rules.
    #   Instead of a service can be used also: iptables-persistent package, /etc/network/if-pre-up.d , /etc/network/interfaces 
    #   useful links:
    #   1. https://help.ubuntu.com/community/IptablesHowTo#Configuration_on_startup
    #   2. https://askubuntu.com/questions/218/command-to-list-services-that-start-on-startup
    #   3. https://wiki.gentoo.org/wiki/OpenRC
    #   4. https://www.lostsaloon.com/technology/how-to-list-all-services-in-linux/
    #   5. always " man " :)
    INIT_PATH=$(readlink -f "$(which init)")
    SYSTEMD_PATH=$(readlink -f "$(which systemd)")
    OPENRC_PATH=$(readlink -f "$(which openrc)")


    TMUR_SAVE() {
            umask 177
            mkdir -p /etc/iptables
	        echo "$ADD_LIST_v4" > /etc/iptables/firewall.list.rules.v4
	        echo "$ADD_LIST_v6" > /etc/iptables/firewall.list.rules.v6
    }


    #   " grep -q init " - will avoid symlink to other system service manager, for example init to systemd
    #   Output of command "service --status-all" can be different for linux distributions, so I can not check if service running or not.
    #   IPTABLES_SERVICES = iptables service list 
    #   function save = saves used rules to a file. System service manager loads service iptables file at system startup.
    if echo "$INIT_PATH" | grep -q init ; then
            SYSTEM_SERVICE_MANAGER="init"
            IPTABLES_SERVICES=$(ls  /etc/init.d/* | grep 'iptables\|ip4tables\|ip6tables\|netfilter' | awk  -F'/' '{print $NF}')
        save() {
            while IFS= read -r LINE_SERVICE ; do
                # Will save to file for iptables-restore
                ${PATH_BIN}service "$LINE_SERVICE" save
            done <<< "${IPTABLES_SERVICES}"
            # Will save to file for Tmur
            TMUR_SAVE
        }	
    elif echo "$SYSTEMD_PATH" | grep -q systemd ; then
            SYSTEM_SERVICE_MANAGER="systemd"
            IPTABLES_SERVICES=$(systemctl --type=service --all | grep 'iptables\|ip4tables\|ip6tables\|netfilter' | awk '{print $1}')
        save() {
            ONE_IPTABLE_SERVICE=$(head -n1 <<< "$IPTABLES_SERVICES")
	        PATH_TO_RULES=$(systemctl cat "$ONE_IPTABLE_SERVICE" | grep ExecStart | awk '{ print $2 }')
            if [ -z "$PATH_TO_RULES" ] ; then
                echo "IPTABLES_SERVICES not found"
            else
                ${PATH_BIN}iptables-save  > "$PATH_TO_RULES"
                ${PATH_BIN}ip6tables-save > "$PATH_TO_RULES"
            fi
            TMUR_SAVE
        }
    elif echo "$OPENRC_PATH" | grep -q openrc ; then
            SYSTEM_SERVICE_MANAGER="openrc"
            IPTABLES_SERVICES=$(ls  /etc/init.d/* | grep 'iptables\|ip4tables\|ip6tables\|netfilter' | awk  -F'/' '{print $NF}')
        save() {
            while IFS= read -r LINE_SERVICE ; do
                ${PATH_BIN}rc-service "$LINE_SERVICE" save
            done <<< "${IPTABLES_SERVICES}"
            TMUR_SAVE
        }
    else
        PRINT_ERROR_NOT_SUPPORTED "System service manager"
    fi
######### Detect system service manager #####}


## ==== System Settings Library ====
######################################################################################}


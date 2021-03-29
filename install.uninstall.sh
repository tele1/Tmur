#!/bin/bash


# Destiny:      Script to install and uninstall tmur script.
# Using the script:     bash tmur --help


VERSION="1"
LICENCE="GPL v3   https://www.gnu.org/licenses/gpl.html "
SOURCE="https://github.com/tele1/Tmur"


##  Name of script (do not use spaces and special characters).
NAME_APP="tmur"

    RC='\e[0;31m' # Red Color
    NC='\e[0m' # No Color


##  Check root running
[[ $EUID -ne 0 ]] && echo -e "${RC} This script must be run as root. ${NC}" && exit 1



#######################################{
##  Options for install I created similar to options in cmake macros for rpm:
##########  Fragment from cmake macros:
##        -DCMAKE_INSTALL_PREFIX:PATH=%{_prefix} \\\
##        -DCMAKE_INSTALL_LIBDIR:PATH=%{_libdir} \\\
##        -DCMAKE_INSTALL_LIBEXECDIR:PATH=%{_libexecdir} \\\
##        -DCMAKE_INSTALL_RUNSTATEDIR:PATH=%{_rundir} \\\
##        -DCMAKE_INSTALL_SYSCONFDIR:PATH=%{_sysconfdir} \\\
##########
##
##  - Folder for installing executable files 
##  INFO:  https://askubuntu.com/questions/308045/differences-between-bin-sbin-usr-bin-usr-sbin-usr-local-bin-usr-local
##  Alternative: INSTALL_PREFIX=/usr/local
INSTALL_PREFIX=/opt
INSTALL_PATH=${INSTALL_PREFIX}/${NAME_APP}
##
##  - Folder for library files 
##  Warning: Linux distributions have lost the standard for "/usr/lib" (they lost not only for this path but that is another story)
##  * distros which use ".deb" packages now keep there 64bit libraries
##  * distros which use ".rpm" packages they still keep there 32bit libraries  
#   INSTALL_LIBDIR=   /usr/lib   or  /usr/lib32  or  /usr/lib64 
##
##  - Folder for config files 
#   INSTALL_SYSCONFDIR=/etc
##
## If you don't know where install read:
##  https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard
##  https://refspecs.linuxfoundation.org/fhs.shtml
#######################################}


PRINT_ERROR_NOT_SUPPORTED() {
    echo "======================"
    echo "--> Error: $1 not found or you have not installed."
    echo "	Ask for help to get help and better support your linux distribution."
    echo "      Write there  https://github.com/tele1/Tmur/issues "
    echo "	And ask the developers of the iptables package in your linux distribution. "
    echo "	"
        read -r -p 'Do you want to continue? y/n ' CHOICE_1
        case "$CHOICE_1" in
            n|N) echo 'Installation canceled. ' ; exit 1;;
            y|Y) echo 'Installation continued.' ;;
            *) echo 'Response not valid' ; exit 1 ;;
        esac
}


# Path to iptables binary
PATH_IPT_BIN=$(dirname $(which iptables) |  awk '{ print $1 "/" }')
if [ ! $(echo "$PATH_IPT_BIN" | grep "\S" | wc -l) -eq "1" ] ; then
    PRINT_ERROR_NOT_SUPPORTED  "Path to iptables"
fi


INSTALL_APP() {
INSTALL_INIT_SERVICE()  {
    echo "This part script is not finished." ;
    echo " Examples in services/init/ " ; exit 1
    # /etc/rc.d/init.d/
    chmod 644 /etc/rc.d/init.d/ip4tables.service
    chmod 644 /etc/rc.d/init.d/ip6tables.service
    service ip4tables.service start
    service ip6tables.service start
}

INSTALL_SYSTEMD_SERVICE()  {
    if [[ -f /etc/systemd/system/ip4tables.service  ]] ; then
        echo "File /etc/systemd/system/ip4tables.service exists. Something is not working. Exiting." ; exit 1
    else
        echo "Flush script will be skipped for systemd."
        echo "Try use firewall instead of this later."
        PATH_INPUT=PATH_TO_IPT_BIN ;
        PATH_OUTPUT="$PATH_IPT_BIN" ;
        sed "s|${PATH_INPUT}|${PATH_OUTPUT}|g" services/systemd/ip4tables.service > /etc/systemd/system/ip4tables.service 
        chmod 644 /etc/systemd/system/ip4tables.service
        sed "s|${PATH_INPUT}|${PATH_OUTPUT}|g" services/systemd/ip6tables.service > /etc/systemd/system/ip6tables.service 
        chmod 644 /etc/systemd/system/ip6tables.service
    fi
    if [[ -f /etc/systemd/system/ip4tables.service  ]] ; then
        echo "File ip4tables.service created."
    else 
        echo "We can not create /etc/systemd/system/ip4tables.service file. Something is not working. Exiting." ; exit 1
    fi
    ${PATH_BIN}iptables-save  > /etc/iptables/ip4tables.rules 
    ${PATH_BIN}ip6tables-save > /etc/iptables/ip6tables.rules
    systemctl enable ip4tables.service
    systemctl start  ip4tables.service
    systemctl enable ip6tables.service
    systemctl start  ip6tables.service
    systemctl status ip4tables.service
    systemctl status ip6tables.service
}

    #### Detect system service manager #####{
    #   More about this in services/README.md
    INIT_PATH=$(readlink -f "$(which init)")
    SYSTEMD_PATH=$(readlink -f "$(which systemd)")
    OPENRC_PATH=$(readlink -f "$(which openrc)")

    # Grep will avoid symlink to systemd
    if echo "$INIT_PATH" | grep -q init ; then
        # Output of command "service --status-all" can be different for linux distributions, so I can not check if service running or not.
        service --status-all | grep -q iptables
        if [ ! $? -eq 0 ]; then
            PRINT_ERROR_NOT_SUPPORTED "Service iptables for init"
            read -r -p 'Do you want try force install iptables service by this script to your system? y/n ' CHOICE_2
            case "$CHOICE_2" in
                n|N) echo 'Service installation canceled. ' ;;
                y|Y) echo 'Installation continued.' ; INSTALL_INIT_SERVICE ;;
                *) echo 'Response not valid' ; exit 1 ;;
            esac
        fi
    elif echo "$SYSTEMD_PATH" | grep -q systemd ; then
        systemctl --type=service --all | grep -q iptables
        if [ ! $? -eq 0 ]; then
            PRINT_ERROR_NOT_SUPPORTED "Service iptables for systemd"
            read -r -p 'Do you want try force install iptables service by this script to your system? y/n ' CHOICE_2
            case "$CHOICE_2" in
                n|N) echo 'Service installation canceled. '  ;;
                y|Y) echo 'Installation continued.' ; INSTALL_SYSTEMD_SERVICE ;;
                *) echo 'Response not valid' ; exit 1 ;;
            esac
        else
            echo "Warning: Systemd not support save option and it can cause problems."
            echo '  Instead of this we will try use: iptables-save -f /path/file '
            #   The path to the file can be different for each linux distribution.
            systemctl cat apport.service | grep ExecStart
        fi
    elif echo "$OPENRC_PATH" | grep -q openrc ; then
        rc-status | grep -q iptables
        if [ ! $? -eq 0 ]; then
            PRINT_ERROR_NOT_SUPPORTED "Service iptables for openrc"
            echo "This part of script is not finished."
        fi
    else
        PRINT_ERROR_NOT_SUPPORTED "System service manager"
    fi



##  Create missing folders, if you don't have: 
##  I tried "install" command but not working as I want.
mkdir -pv ${INSTALL_PATH}
cp -rv tmur  "${INSTALL_PATH}"
cp -rv doc ${INSTALL_PATH}
cp -rv lib ${INSTALL_PATH}
cp -rv rules ${INSTALL_PATH}
cp -v README.md ${INSTALL_PATH}
cp -v LICENSE ${INSTALL_PATH}
cp -v install.uninstall.sh ${INSTALL_PATH}

## Create symbolic link for $PATH
ln -s ${INSTALL_PATH}/tmur /usr/sbin/tmur

#########################################{
## DISABLED:
##  I tried add icon to menu for open tmur with xterm 
##  but "xterm -ls -hold -e" does not work together

##  For run xterm from root on Ubuntu you need create scriptwith: pkexec "/usr/bin/xterm" "$@"

##  Own item to menu
#cat <<'EOF' >> ${NAME_APP}.desktop
#[Desktop Entry]
#Type=Application
#Terminal=false
#Name=tmur
#Exec=xterm -hold -e "/opt/tmur/tmur --help"
#Icon=terminal
#EOF

##  You can read:
##  Desktop Entry File
##  https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
## You can check local list of mime, to find file run: locate mimeapps.list    
##  https://www.freedesktop.org/wiki/Specifications/shared-mime-info-spec/
##  https://www.freedesktop.org/wiki/Specifications/mime-apps-spec/
##  https://specifications.freedesktop.org/menu-spec/latest/apa.html
##  https://wiki.archlinux.org/index.php/Autostarting
##  https://wiki.archlinux.org/index.php/Desktop_entries

##  Validation (Alternative):
#desktop-file-validate ${NAME_APP}.desktop || echo "Error: desktop-file-validate"

##  Install Desktop Entry
#desktop-file-install --dir=/usr/share/applications ${NAME_APP}.desktop || echo "Error: desktop-file-install"
##  Alternative: mv ${NAME}.desktop /usr/share/applications/ 
##  Alternative: install -Dm644 mv ${NAME}.desktop /usr/share/applications/

##  Update database of desktop entries:
#update-desktop-database /usr/share/applications || echo "Error: update-desktop-database"

##  Clean 
#rm -v ${NAME_APP}.desktop && echo "Removed temporary file."
#########################################}

##  Give correct permissions
##  755 - binary , 644 - other
chown -R root:root ${INSTALL_PATH}
chmod -R 644 ${INSTALL_PATH} 
chmod    755 ${INSTALL_PATH}/tmur
chmod    755 ${INSTALL_PATH}/install.uninstall.sh 


################{
## == Checking file permissions ==
# Find files with "suid" or "sgid" flag.
if [[ ! "$(find ${INSTALL_PATH}  -perm /4000 -o -perm /2000 -o -perm /6000 | wc -l)" == "0" ]]; then
    echo "------------------"
    echo -e "${RC} Potentially dangerous files: ${NC}"
    find ${INSTALL_PATH} -perm /4000 -o -perm /2000 -o -perm /6000
    echo -e "${RC} Warning!  ${NC}"
    echo -e "${RC} Found "suid" or "sgid" flag. Using firefox can be dangerous. ${NC}"
    exit 1
fi
# Find writable files
if [[ ! "$(find ${INSTALL_PATH} -perm -o+w | wc -l)" == "0" ]]; then
    echo "------------------"
    echo -e "${RC} Potentially dangerous files: ${NC}"
    find ${INSTALL_PATH} -perm -o+w
    echo -e "${RC} Warning!  ${NC}"
    echo -e "${RC} Found writable files. ${NC}"
    exit 1
fi
## == Checking file permissions ==
################}
}



UNINSTALL_APP() {
if [ -d ${INSTALL_PATH} ] ;then
    rm -rfv ${INSTALL_PATH}
    rm -v   /usr/sbin/tmur

#    rm -rv /usr/share/applications/${NAME_APP}.desktop
#    ##  Update database of desktop entries:
#    update-desktop-database /usr/share/applications
fi
[ -d "${INSTALL_PATH}" ] || echo "--> Removal ${INSTALL_PATH} completed successfully"
[ -d "${INSTALL_PATH}" ] && echo "--> ${RC}Error: Removal ${INSTALL_PATH} failed ${NC}"
}

###################{
case $1 in
	"--install")
	INSTALL_APP
	;;

	"--uninstall")
	UNINSTALL_APP
	;;

	"--help")
	echo "Usage: [SCRIPT_NAME] [OPTION]"
	echo " "
	echo "      --install               install app"
	echo "      --uninstall             remove app"
	echo "      --help                  display this help and exit"
	echo "      --version               output version information and exit"
	echo " "
	;;

	"--version")
	echo "Script Version: $VERSION"
	echo "Licence: $LICENCE"
	;;

	*)
            echo "###########################################"
			echo "--> Incorrect option."
			echo " Write " --help " to show available options."
			echo "###########################################"
	;;
esac
###################}

##########################{
##  1. Other way install tmur for Debian , Linux mint , Ubuntu
##      install app with checkinstall (This create simple .deb package and is not portable):
##          su -c 'mkdir -p /opt/your_app_name/' 
##          checkinstall --install=no --maintainer=your_user_name --pkgname=your_app_name --pkgversion=version_number --pkglicense="GPL v.3" --provides=your_app_name --nodoc  
##  2. Check ready package (read-only permissions and location of files):
##          dpkg -c *.deb
##  3. Install from root: (with "su -c" for Debian or with "sudo" for Ubuntu)
##          su -c 'dpkg -i app_name_version.deb'
##  4. Edit /etc/profile to add path to folder with executable files to run app from root (There should be only executable files):
##          if [ "`id -u`" -eq 0 ]; then
##          PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
##          PATH="$PATH:/opt/Your_path_for_app"
##          else
##          PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
##          fi
##          export PATH
##  5. Reload $PATH:
##          source /etc/profile
##  6. Check $PATH:
##          echo $PATH
##  7. Add to ~/.bashrc
##          if [ -d "/opt/yad/" ] ; then
##              PATH="$PATH:/opt/yad"
##          fi
##  8. Other way instead 4. 5. 6. 7. points above is just create symbolic link for your app. (ln -s target_path link_path)
##  From /usr/bin/ folder and from root:
##          ln -s app_name    /opt/app_name/app_name
##  
##########################}

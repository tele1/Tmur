#!/bin/bash


####################################{
## == Message Library ==

## ANSI code
## doc.: https://en.wikipedia.org/wiki/ANSI_escape_code
## doc.: http://www.real-world-systems.com/docs/ANSIcode.html
## doc.: https://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
NC='\e[0m'    # Reset Color
BL='\e[0;36m' # Cyan ECHO
GN='\e[0;32m' # Green ECHO
YW='\e[0;33m' # Yellow ECHO
RD='\e[0;31m' # Red ECHO


#----------------{
MESSAGE_DEBUG() {
    if [[ "$DEBUG" == "ON" ]] ; then
        echo -e "${BL}  DEBUG: $1 ${NC}"
    fi
}
#----------------}


MESSAGE_INFO() {
    echo "----"
    echo -e "${GN}  INFO: $1 ${NC}"
    echo "----"
}


MESSAGE_WARNING() {
    # Print text in red and redirect to error
	echo -e "${YW}  WARNING: $* ${NC}" 1>&2
    #; exit 1
}


MESSAGE_ERROR() {
    # print text in red and redirect to error
	echo -e "${RD}  ERROR: $@ ${NC}" 1>&2
    #; exit 1
}


PRINT_ERROR_NOT_SUPPORTED() {
    #   Use of a SUPPORT variable forces the declaration of this variable in the script you are running.
    printf "${RD}%s${NC}" "======================"
    printf "${RD}%s${NC}" "--> Error: $1 not found or you have not installed."
    printf "${RD}%s${NC}" "	 Ask developers your linux distributionfor to get help and better support."
    printf "${RD}%s${NC}" "  And write also there  $SUPPORT "
    printf "${RD}%s${NC}" "Exiting."
    exit 1
}

## == Message library ==
####################################}


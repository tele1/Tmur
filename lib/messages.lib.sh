#!/bin/bash


## ANSI code
## doc.: https://en.wikipedia.org/wiki/ANSI_escape_code
## doc.: http://www.real-world-systems.com/docs/ANSIcode.html
## doc.: https://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
NC='\e[0m'    # Reset Color
YW='\e[0;33m' # Yellow ECHO
GN='\e[0;32m' # Green ECHO
RD='\e[0;31m' # Red ECHO


#----------------{
MESSAGE_DEBUG() {
    #DEBUG="OFF / ON"
    DEBUG="ON"
    if [[ "$DEBUG" == "ON" ]] ; then
        echo -e "${YW}  DEBUG: $1 ${NC}"
    fi
}
#----------------}


MESSAGE_INFO() {
    echo "----"
    echo -e "${GN}  INFO: $1 ${NC}"
    echo "----"
}


MESSAGE_ERROR() {
    # print text in red and redirect to error
	echo -e "${RD}  ERROR: $@ ${NC}" 1>&2
    #; exit 1
}

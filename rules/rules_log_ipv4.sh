
# Log lvl : http://fibrevillage.com/sysadmin/202-enable-linux-${PATH_BIN}iptables-logging
# Logging : https://tecadmin.net/enable-logging-in-${PATH_BIN}iptables-on-linux/



log4_localhost() {
echo " > $FUNCNAME"
## Log rule will work also with other log rules.
${PATH_BIN}iptables -I INPUT  -s 127.0.0.1 -j LOG \
-m limit --limit 1/hour --limit-burst 1 \
--log-prefix "IPTABLES: log4_localhost " -m comment --comment "IPTABLES: log4_localhost"
}




log4_output() {
echo " > $FUNCNAME"
## Log rule will work also with other log rules.
${PATH_BIN}iptables -I OUTPUT -j LOG \
-m limit --limit 1/hour --limit-burst 1 \
--log-prefix "IPTABLES: log4_output " -m comment --comment "IPTABLES: log4_output"
}




log4_input() {
echo " > $FUNCNAME"
## Log rule will work also with other log rules.
${PATH_BIN}iptables -I INPUT -j LOG \
-m limit --limit 1/hour --limit-burst 1 \
--log-prefix "IPTABLES: log4_input " -m comment --comment "IPTABLES: log4_input"
}




log4_input2() {
    echo " > $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"
${PATH_BIN}iptables -I INPUT -p tcp  $LOG
${PATH_BIN}iptables -I INPUT -p udp  $LOG
${PATH_BIN}iptables -I INPUT -p icmp $LOG
${PATH_BIN}iptables -I INPUT -f      $LOG
}




log4_INPUT_OUTPUT() {
    echo " > $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"
${PATH_BIN}iptables -I INPUT  $LOG
${PATH_BIN}iptables -I OUTPUT $LOG
}



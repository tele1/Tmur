



log_v4_localhost() {
echo " > $FUNCNAME"
## Log rule will work also with other log rules.
${PATH_BIN}iptables -I INPUT  -s 127.0.0.1 -j LOG \
-m limit --limit 1/hour --limit-burst 1 \
--log-prefix "IPTABLES: log_v4_localhost " -m comment --comment "IPTABLES: log_v4_localhost"
}




log_v4_output() {
echo " > $FUNCNAME"
## Log rule will work also with other log rules.
${PATH_BIN}iptables -I OUTPUT -j LOG \
-m limit --limit 1/hour --limit-burst 1 \
--log-prefix "IPTABLES: log_v4_output " -m comment --comment "IPTABLES: log_v4_output"
}




log_v4_input() {
echo " > $FUNCNAME"
## Log rule will work also with other log rules.
${PATH_BIN}iptables -I INPUT -j LOG \
-m limit --limit 1/hour --limit-burst 1 \
--log-prefix "IPTABLES: log_v4_input " -m comment --comment "IPTABLES: log_v4_input"
}




log_v4_input2() {
echo " > $FUNCNAME"
${PATH_BIN}iptables -I INPUT -p tcp -m limit --limit 1/hour --limit-burst 1 -j LOG --log-prefix "IPTABLES: log_v4_input2 " -m comment --comment "IPTABLES: log_v4_input21"
${PATH_BIN}iptables -I INPUT -p udp -m limit --limit 1/hour --limit-burst 1 -j LOG --log-prefix "IPTABLES: log_v4_input2 " -m comment --comment "IPTABLES: log_v4_input22"
${PATH_BIN}iptables -I INPUT -p icmp -m limit --limit 1/hour --limit-burst 1 -j LOG --log-prefix "IPTABLES: log_v4_input2 " -m comment --comment "IPTABLES: log_v4_input23"
${PATH_BIN}iptables -I INPUT -f -m limit --limit 1/hour --limit-burst 1 -j LOG --log-prefix "IPTABLES: log_v4_input2 " -m comment --comment "IPTABLES: log_v4_input24"
}




accept_v4_log_INPUT_and_OUTPUT() {
${PATH_BIN}iptables -A INPUT -j LOG --log-prefix "INPUT info:" --log-level 6
${PATH_BIN}iptables -A OUTPUT -j LOG --log-prefix "OUTPUT info:" --log-level 6
}

# Log lvl : http://fibrevillage.com/sysadmin/202-enable-linux-${PATH_BIN}iptables-logging
# Logging : https://tecadmin.net/enable-logging-in-${PATH_BIN}iptables-on-linux/

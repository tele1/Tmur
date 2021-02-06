



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

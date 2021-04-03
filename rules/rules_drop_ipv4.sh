


drop4_ack_scan() {
## PROTECTION BEFORE SCANNING ACK SCAN
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

${PATH_IPT_BIN}/iptables -I INPUT -m conntrack --ctstate NEW -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH ACK $DROP
${PATH_IPT_BIN}/iptables -I INPUT -m conntrack --ctstate NEW -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH ACK $LOG 
}




drop4_fin_scan() {
## PROTECTION BEFORE SCANNING FIN SCAN
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

# Iptables not logged with {-m conntrack --ctstate NEW} so I will not use them here.
${PATH_IPT_BIN}/iptables -I INPUT -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH FIN $DROP
${PATH_IPT_BIN}/iptables -I INPUT -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH FIN $LOG
}




drop4_localhost() {
    echo " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

${PATH_IPT_BIN}/iptables -I INPUT  -s 127.0.0.1 $DROP
${PATH_IPT_BIN}/iptables -I INPUT  -s 127.0.0.1 $LOG
}




drop4_xmas_scan() {
## PROTECTION BEFORE SCANNING XMAS TREE SCAN
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

# Iptables not logged with {-m conntrack --ctstate NEW} so I will not use them here.
${PATH_IPT_BIN}/iptables -I INPUT  -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH FIN,URG,PSH  $DROP
${PATH_IPT_BIN}/iptables -I INPUT  -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH FIN,URG,PSH  $LOG

# Other:
# https://github.com/trimstray/iptables-essentials#xmas-packets
# https://serverfault.com/questions/314674/block-nmap-xmas-scan-from-detecting-my-servers-open-port
# https://www.cyberciti.biz/tips/linux-iptables-10-how-to-block-common-attack.html
}




drop4_null_scan() {
## PROTECTION BEFORE NULL SCAN
## WARNING: RULE WILL BLOCK WEB BROWSER
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

# Iptables not logged with {-m conntrack --ctstate NEW} so I will not use them here.
${PATH_IPT_BIN}/iptables -I INPUT  -p tcp ! --tcp-flags SYN,RST,ACK,FIN,PSH,URG SYN,RST,ACK,FIN,PSH,URG $DROP
${PATH_IPT_BIN}/iptables -I INPUT  -p tcp ! --tcp-flags SYN,RST,ACK,FIN,PSH,URG SYN,RST,ACK,FIN,PSH,URG $LOG
}




drop4_ping() {
# BLOCKING PING
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

${PATH_IPT_BIN}/iptables -I INPUT -p icmp --icmp-type echo-request $DROP
${PATH_IPT_BIN}/iptables -I INPUT -p icmp --icmp-type 8            $LOG
}




drop4_telnet() {
# BLOCKING TELNET PORT
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

${PATH_IPT_BIN}/iptables -I INPUT  -p tcp --dport telnet $DROP
${PATH_IPT_BIN}/iptables -I INPUT  -p tcp --dport telnet $LOG
${PATH_IPT_BIN}/iptables -I OUTPUT -p tcp --dport telnet $DROP
${PATH_IPT_BIN}/iptables -I OUTPUT -p tcp --dport telnet $LOG 
}




drop4_invalid() {
# BLOCKING INVALID PACKAGES
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}: --log-ip-options --log-tcp-options"

${PATH_IPT_BIN}/iptables -I INPUT  -m state --state INVALID $DROP
${PATH_IPT_BIN}/iptables -I INPUT  -m state --state INVALID $LOG 
${PATH_IPT_BIN}/iptables -I OUTPUT -m state --state INVALID $DROP
${PATH_IPT_BIN}/iptables -I OUTPUT -m state --state INVALID $LOG 
}




#drop4_spoofing() {
#echo -e " > $FUNCNAME"
## ANTY-SPOOFING
#${PATH_IPT_BIN}/iptables -I INPUT -i $ETH -s ! 192.168.1.0/24 -j LOG --log-prefix "INPUT SPOOFED PKT "
#${PATH_IPT_BIN}/iptables -I INPUT -i $ETH -s ! 192.168.1.0/24 -j DROP

##or

#${PATH_IPT_BIN}/iptables -N spoofing
#${PATH_IPT_BIN}/iptables -I spoofing -j LOG --log-prefix "Spoofed source IP"
#${PATH_IPT_BIN}/iptables -I spoofing -j DROP

#${PATH_IPT_BIN}/iptables -A INPUT -s 255.0.0.0/8 -j spoofing
#${PATH_IPT_BIN}/iptables -A INPUT -s 0.0.0.8/8 -j spoofing
#}




drop4_null() {
# Drop all NULL packets
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

${PATH_IPT_BIN}/iptables -I INPUT -p tcp --tcp-flags ALL NONE $DROP
${PATH_IPT_BIN}/iptables -I INPUT -p tcp --tcp-flags ALL NONE $LOG 
}




drop4_bruteforce_ssh() {
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

${PATH_IPT_BIN}/iptables -I INPUT -p tcp --dport 22  -m state --state NEW -m recent --set
${PATH_IPT_BIN}/iptables -I INPUT -p tcp --dport 22  -m state --state NEW -m recent  --update --seconds 60 --hitcount 4 $DROP
# will block an IP if it attempts more than 3 connections per minute to SSH
# https://www.rackaid.com/blog/how-to-block-ssh-brute-force-attacks/
}




drop4_ident() {
# To prevent ICMP unreachable packets being sent
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

${PATH_IPT_BIN}/iptables -I OUTPUT -p icmp --icmp-type destination-unreachable $DROP
# Protection against attack IDENT i SOCK SCANNING 
${PATH_IPT_BIN}/iptables -I INPUT -p tcp --dport 113 -j REJECT --reject-with icmp-port-unreachable
${PATH_IPT_BIN}/iptables -I INPUT -p tcp --dport 1080 -j REJECT --reject-with icmp-port-unreachable
}




drop4_scan() {
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

# Anyone who scans us will be blocked for a whole day:
${PATH_IPT_BIN}/iptables -I INPUT   -m recent --name portscan --rcheck --seconds 86400 $DROP
${PATH_IPT_BIN}/iptables -I FORWARD -m recent --name portscan --rcheck --seconds 86400 $DROP
# After a day, it will be removed from the "scan list"
${PATH_IPT_BIN}/iptables -I INPUT   -m recent --name portscan --remove
${PATH_IPT_BIN}/iptables -I FORWARD -m recent --name portscan --remove
}




drop4_from_list_scaners() {
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

# Rules which add scanners to the "scanner list" and save scan attempts:
${PATH_IPT_BIN}/iptables -I INPUT   -p tcp -m tcp --dport 139 -m recent --name portscan --set $DROP
${PATH_IPT_BIN}/iptables -I INPUT   -p tcp -m tcp --dport 139 -m recent --name portscan --set $LOG

${PATH_IPT_BIN}/iptables -I FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set $DROP
${PATH_IPT_BIN}/iptables -I FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set $LOG
}




drop4_unclean() {
echo -e " > $FUNCNAME"
# Dropping atypical packets ( Experimental module “unclean” )
echo " This is Experimental module “unclean”"
${PATH_IPT_BIN}/iptables -I INPUT -j DROP -m unclean
}

drop4_hole_1() {
echo -e " > $FUNCNAME"
# Closing the gap in ${PATH_IPT_BIN}/iptables # 
${PATH_IPT_BIN}/iptables -I OUTPUT -m state -p icmp --state INVALID -j DROP
}




drop4_upnp() {
echo " > $FUNCNAME"
${PATH_IPT_BIN}/iptables -I INPUT -p tcp --sport 2869 -j DROP \
-m comment --comment "drop_upnp" 
${PATH_IPT_BIN}/iptables -I INPUT -p udp --sport 1900 -j DROP \
-m comment --comment "drop_upnp" 
}

## Upuszczanie polaczen nie zainicjowanych przez naszego hosta:
## ${PATH_IPT_BIN}/iptables -A INPUT -p tcp --syn -j DROP

## Uszczelnienie reguł dla nowych połączeń
## ${PATH_IPT_BIN}/iptables -A INPUT -i $ETH -p tcp ! --syn -m state --state NEW -j LOG --log-level debug --log-prefix "IPT BAD NEW: "
## ${PATH_IPT_BIN}/iptables -A INPUT -i $ETH -p tcp ! --syn -m state --state NEW -j DROP




drop4_cups() {
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

${PATH_IPT_BIN}/iptables -I INPUT  -p tcp --sport 631 $DROP
${PATH_IPT_BIN}/iptables -I INPUT  -p udp --sport 631 $DROP
${PATH_IPT_BIN}/iptables -I OUTPUT -p tcp --dport 631 $DROP
${PATH_IPT_BIN}/iptables -I OUTPUT -p udp --dport 631 $DROP
}




drop4_low_MSS() {
echo " > $FUNCNAME"
## block connections with low MSSs
## https://github.com/Netflix/security-bulletins/blob/master/advisories/third-party/2019-001.md
## https://github.com/Netflix/security-bulletins/blob/master/advisories/third-party/2019-001/block-low-mss/iptables.txt
${PATH_IPT_BIN}/iptables -I INPUT -p tcp -m tcpmss --mss 1:500 -j DROP
##${PATH_IPT_BIN}/ip6tables -I INPUT -p tcp -m tcpmss --mss 1:500 -j DROP
}




drop4_DNS_Tunneling() {
echo " > $FUNCNAME"
## NOT TESTED YET, but you can test :)
##  https://www.youtube.com/watch?v=q3dPih_8Cro
##  https://inside-out.xyz/technology/how-dns-tunneling-works.html

## For client
## The maximum value of characters for --log-prefix and --comment is 29.
COMMENT="-m comment --comment $FUNCNAME"
LOG="LOG --log-prefix IPTA:${FUNCNAME}:"
${PATH_IPT_BIN}/iptables -I OUTPUT -p udp --dport 53 -m length --length 1025:65535 -j DROP $COMMENT
${PATH_IPT_BIN}/iptables -I OUTPUT -p udp --dport 53 -m length --length 1025:65535 -j $LOG

${PATH_IPT_BIN}/iptables -I OUTPUT -p udp --sport 53 -m length --length 1025:65535 -j DROP $COMMENT
${PATH_IPT_BIN}/iptables -I OUTPUT -p udp --sport 53 -m length --length 1025:65535 -j $LOG

${PATH_IPT_BIN}/iptables -I OUTPUT -p tcp --dport 53 -m length --length 1025:65535 -j DROP $COMMENT
${PATH_IPT_BIN}/iptables -I OUTPUT -p tcp --dport 53 -m length --length 1025:65535 -j $LOG

${PATH_IPT_BIN}/iptables -I OUTPUT -p tcp --sport 53 -m length --length 1025:65535 -j DROP $COMMENT
${PATH_IPT_BIN}/iptables -I OUTPUT -p tcp --sport 53 -m length --length 1025:65535 -j $LOG
}




drop4_ddos() {
# PROTECTION BEFORE ATTACK Dos
# I don't know how it works 
    echo -e " > $FUNCNAME"
    COMMENT="-m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/s --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

${PATH_IPT_BIN}/iptables -I INPUT -m conntrack --ctstate INVALID -p tcp ! --tcp-flags SYN,RST,ACK,FIN,PSH,URG SYN,RST $COMMENT
${PATH_IPT_BIN}/iptables -N syn-flood $COMMENT
${PATH_IPT_BIN}/iptables -I INPUT -p tcp --syn -j syn-flood $COMMENT
${PATH_IPT_BIN}/iptables -I syn-flood -m limit --limit 1/s --limit-burst 4 -j RETURN $COMMENT
${PATH_IPT_BIN}/iptables -I syn-flood $LOG
${PATH_IPT_BIN}/iptables -I syn-flood -j DROP $COMMENT
}




drop4_ping_death() {
# PROTECTION BEFORE ATTACK PING OF DEATH 
    echo -e " > $FUNCNAME"
    ACCEPT="-j ACCEPT -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/s --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

# "To protect some really old equipment. For new devices probably is unnecessary."
# limits the number of pings 
${PATH_IPT_BIN}/iptables -I INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s $ACCEPT
${PATH_IPT_BIN}/iptables -I INPUT -p icmp --icmp-type echo-request $LOG
}




drop4_ping_death_v2() {
# PROTECTION BEFORE ATTACK PING OF DEATH 
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

# "To protect some really old equipment. For new devices probably is unnecessary."
${PATH_IPT_BIN}/iptables -I INPUT -p icmp -f $DROP
${PATH_IPT_BIN}/iptables -I INPUT -p icmp -f $LOG

# Yet another way 
#https://blacksaildivision.com/secure-iptables-rules-centos
}




drop4_fragments() {
# Packets with incoming fragments drop them.
    echo -e " > $FUNCNAME"
    DROP="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

${PATH_IPT_BIN}/iptables -I INPUT -f $DROP
${PATH_IPT_BIN}/iptables -I INPUT -f $LOG
}


#------------------DROP------------------}


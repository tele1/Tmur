

drop_v4_ack_scan() {
echo -e " > $FUNCNAME"
## PROTECTION BEFORE SCANNING ACK SCAN
${PATH_BIN}iptables -I INPUT -m conntrack --ctstate NEW -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH ACK -j DROP  \
-m comment --comment "IPTABLES: drop_v4_ack_scan" 

## LOG
${PATH_BIN}iptables -I INPUT -m conntrack --ctstate NEW -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH ACK -j LOG \
-m limit --limit 1/hour --limit-burst 1 \
--log-prefix "IPTABLES: drop_v4_ack_scan " -m comment --comment "IPTABLES: drop_v4_ack_scan"
}






drop_v4_ack_scan_long_long2_long3_long4() {
echo -e " > $FUNCNAME"
## PROTECTION BEFORE SCANNING ACK SCAN
    COMMENT="-j DROP -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPTABLES:${FUNCNAME}:"

${PATH_BIN}iptables -I INPUT -m conntrack --ctstate NEW -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH ACK $DROP
${PATH_BIN}iptables -I INPUT -m conntrack --ctstate NEW -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH ACK $LOG 
}





drop_v4_fin_scan() {
echo -e " > $FUNCNAME"
## PROTECTION BEFORE SCANNING FIN SCAN
${PATH_BIN}iptables -I INPUT -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH FIN -j DROP \
-m comment --comment "IPTABLES: drop_v4_fin_scan" 

## LOG
# Not logged with {-m conntrack --ctstate NEW} so I will not use them here.
${PATH_BIN}iptables -I INPUT -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH FIN -j LOG \
-m limit --limit 1/hour --limit-burst 1 \
--log-prefix "IPTABLES: drop_v4_fin_scan " -m comment --comment "IPTABLES: drop_v4_fin_scan"
}




drop_v4_localhost() {
echo " > $FUNCNAME"
${PATH_BIN}iptables -I INPUT  -s 127.0.0.1 -j DROP \
-m comment --comment "IPTABLES: drop_v4_localhost" 

## LOG
## Log rule will work also with other log rules.
${PATH_BIN}iptables -I INPUT  -s 127.0.0.1 -j LOG \
--log-prefix "IPTABLES: log1_v4_localhost " -m comment --comment "IPTABLES: drop_v4_localhost"
}




drop_v4_xmas_scan() {
echo -e " > $FUNCNAME"
## PROTECTION BEFORE SCANNING XMAS TREE SCAN
${PATH_BIN}iptables -I INPUT  -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH FIN,URG,PSH -j DROP \
-m comment --comment "IPTABLES: drop_v4_xmas_scan"

## LOG
# Not logged with {-m conntrack --ctstate NEW} so I will not use them here.
${PATH_BIN}iptables -I INPUT  -p tcp --tcp-flags SYN,RST,ACK,FIN,URG,PSH FIN,URG,PSH -j LOG \
-m limit --limit 1/hour --limit-burst 1 \
--log-prefix "IPTABLES: drop_v4_xmas_scan " -m comment --comment "IPTABLES: drop_v4_xmas_scan"

# Other:
# https://github.com/trimstray/iptables-essentials#xmas-packets
# https://serverfault.com/questions/314674/block-nmap-xmas-scan-from-detecting-my-servers-open-port
# https://www.cyberciti.biz/tips/linux-iptables-10-how-to-block-common-attack.html
}




drop_v4_null_scan() {
echo -e " > $FUNCNAME"
# PROTECTION BEFORE NULL SCAN
## WARNING: RULE WILL BLOCK WEB BROWSER
# Not logged with {-m conntrack --ctstate INVALID} so I will not use them here.
${PATH_BIN}iptables -I INPUT  -p tcp ! --tcp-flags SYN,RST,ACK,FIN,PSH,URG SYN,RST,ACK,FIN,PSH,URG -j DROP -m comment --comment "IPTABLES: drop_v4_null_scan"

## LOG
# Not logged with {-m conntrack --ctstate INVALID} so I will not use them here.
${PATH_BIN}iptables -I INPUT  -p tcp ! --tcp-flags SYN,RST,ACK,FIN,PSH,URG SYN,RST,ACK,FIN,PSH,URG -j LOG \
-m limit --limit 1/hour --limit-burst 1 \
--log-prefix "IPTABLES: drop_v4_null_scan " -m comment --comment "IPTABLES: drop_v4_null_scan"
}




drop_v4_ping() {
echo -e " > $FUNCNAME"
# BLOCKING PING
${PATH_BIN}iptables -I INPUT -p icmp --icmp-type echo-request -j DROP \
-m comment --comment "IPTABLES: drop_v4_ping "

${PATH_BIN}iptables -I INPUT -p icmp --icmp-type 8 -j LOG \
-m limit --limit 1/hour --limit-burst 1 --log-prefix "IPTABLES: drop_v4_ping " --log-level 4 \
-m comment --comment "IPTABLES: drop_v4_ping "
}




drop_v4_telnet() {
echo -e " > $FUNCNAME"
# BLOCKING TELNET PORT
${PATH_BIN}iptables -I INPUT -p tcp --dport telnet -j DROP \
-m comment --comment "IPTABLES: drop_v4_telnet in"
${PATH_BIN}iptables -I INPUT -p tcp --dport telnet -j LOG \
--log-prefix "IPTABLES: drop_v4_telnet in " \
-m comment --comment "IPTABLES: drop_v4_telnet in " -m limit --limit 1/hour --limit-burst 1

${PATH_BIN}iptables -I OUTPUT -p tcp --dport telnet -j DROP \
-m comment --comment "IPTABLES: drop_v4_telnet out"
${PATH_BIN}iptables -I OUTPUT -p tcp --dport telnet -j LOG \
--log-prefix "IPTABLES: drop_v4_telnet out " \
-m comment --comment "IPTABLES: drop_v4_telnet out " -m limit --limit 1/hour --limit-burst 1
}




drop_v4_invalid() {
echo -e " > $FUNCNAME"
# BLOCKING INVALID PACKAGES
${PATH_BIN}iptables -I INPUT  -m state --state INVALID -j DROP
${PATH_BIN}iptables -I INPUT  -m state --state INVALID -j LOG --log-prefix "IPTABLES: drop_v4_invalid in "  --log-ip-options --log-tcp-options
${PATH_BIN}iptables -I OUTPUT -m state --state INVALID -j DROP
${PATH_BIN}iptables -I OUTPUT -m state --state INVALID -j LOG --log-prefix "IPTABLES: drop_v4_invalid out " --log-ip-options --log-tcp-options
}




#drop_v4_spoofing() {
#echo -e " > $FUNCNAME"
## ANTY-SPOOFING
#${PATH_BIN}iptables -I INPUT -i $ETH -s ! 192.168.1.0/24 -j LOG --log-prefix "INPUT SPOOFED PKT "
#${PATH_BIN}iptables -I INPUT -i $ETH -s ! 192.168.1.0/24 -j DROP

##or

#${PATH_BIN}iptables -N spoofing
#${PATH_BIN}iptables -I spoofing -j LOG --log-prefix "Spoofed source IP"
#${PATH_BIN}iptables -I spoofing -j DROP

#${PATH_BIN}iptables -A INPUT -s 255.0.0.0/8 -j spoofing
#${PATH_BIN}iptables -A INPUT -s 0.0.0.8/8 -j spoofing
#}




drop_v4_null() {
echo -e " > $FUNCNAME"
# Drop all NULL packets
${PATH_BIN}iptables -I INPUT -p tcp --tcp-flags ALL NONE -j DROP
}




drop_v4_bruteforce_ssh() {
echo -e " > $FUNCNAME"
${PATH_BIN}iptables -I INPUT -p tcp --dport 22 -i $ETH -m state --state NEW -m recent --set
${PATH_BIN}iptables -I INPUT -p tcp --dport 22 -i $ETH -m state --state NEW -m recent  --update --seconds 60 --hitcount 4 -j DROP
# will block an IP if it attempts more than 3 connections per minute to SSH
# https://www.rackaid.com/blog/how-to-block-ssh-brute-force-attacks/
}




drop_v4_ident() {
echo -e " > $FUNCNAME"
# To prevent ICMP unreachable packets being sent
${PATH_BIN}iptables -I OUTPUT -p icmp --icmp-type destination-unreachable -j DROP
# Protection against attack IDENT i SOCK SCANNING 
${PATH_BIN}iptables -I INPUT -p tcp --dport 113 -j REJECT --reject-with icmp-port-unreachable
${PATH_BIN}iptables -I INPUT -p tcp --dport 1080 -j REJECT --reject-with icmp-port-unreachable
}




drop_v4_scan() {
echo -e " > $FUNCNAME"
# Anyone who scans us will be blocked for a whole day:
${PATH_BIN}iptables -I INPUT   -m recent --name portscan --rcheck --seconds 86400 -j DROP
${PATH_BIN}iptables -I FORWARD -m recent --name portscan --rcheck --seconds 86400 -j DROP
# After a day, it will be removed from the "scan list"
${PATH_BIN}iptables -I INPUT   -m recent --name portscan --remove
${PATH_BIN}iptables -I FORWARD -m recent --name portscan --remove
}




drop_v4_from_list_scaners() {
echo -e " > $FUNCNAME"
# Regoly, ktore dodaja skanujacych do “ listy skanerow “ I zapisuja proby skanow:
${PATH_BIN}iptables -I INPUT   -p tcp -m tcp --dport 139 \
    -m recent --name portscan --set -j LOG --log-prefix "Portscan:"
${PATH_BIN}iptables -I INPUT   -p tcp -m tcp --dport 139 \
    -m recent --name portscan --set -j DROP

${PATH_BIN}iptables -I FORWARD -p tcp -m tcp --dport 139 \
    -m recent --name portscan --set -j LOG --log-prefix "Portscan:"
${PATH_BIN}iptables -I FORWARD -p tcp -m tcp --dport 139 \
    -m recent --name portscan --set -j DROP
}




drop_v4_unclean() {
echo -e " > $FUNCNAME"
# Dropping atypical packets ( Experimental module “unclean” )
echo " This is Experimental module “unclean”"
${PATH_BIN}iptables -I INPUT -j DROP -m unclean
}

drop_v4_hole_1() {
echo -e " > $FUNCNAME"
# Closing the gap in ${PATH_BIN}iptables # 
${PATH_BIN}iptables -I OUTPUT -m state -p icmp --state INVALID -j DROP
}




drop_v4_upnp() {
echo " > $FUNCNAME"
${PATH_BIN}iptables -I INPUT -p tcp --sport 2869 -j DROP \
-m comment --comment "drop_upnp" 
${PATH_BIN}iptables -I INPUT -p udp --sport 1900 -j DROP \
-m comment --comment "drop_upnp" 
}

## Upuszczanie polaczen nie zainicjowanych przez naszego hosta:
## ${PATH_BIN}iptables -A INPUT -p tcp --syn -j DROP

## Uszczelnienie reguł dla nowych połączeń
## ${PATH_BIN}iptables -A INPUT -i $ETH -p tcp ! --syn -m state --state NEW -j LOG --log-level debug --log-prefix "IPT BAD NEW: "
## ${PATH_BIN}iptables -A INPUT -i $ETH -p tcp ! --syn -m state --state NEW -j DROP




drop_v4_cups() {
echo " > $FUNCNAME"
${PATH_BIN}iptables -I INPUT -p tcp --sport 631 -j REJECT \
-m comment --comment "drop_cups" 
${PATH_BIN}iptables -I INPUT -p udp --sport 631 -j REJECT \
-m comment --comment "drop_cups" 
${PATH_BIN}iptables -I OUTPUT -p tcp --dport 631 -j REJECT \
-m comment --comment "drop_cups" 
${PATH_BIN}iptables -I OUTPUT -p udp --dport 631 -j REJECT \
-m comment --comment "drop_cups" 
}




drop_v4_low_MSS() {
echo " > $FUNCNAME"
## block connections with low MSSs
## https://github.com/Netflix/security-bulletins/blob/master/advisories/third-party/2019-001.md
## https://github.com/Netflix/security-bulletins/blob/master/advisories/third-party/2019-001/block-low-mss/iptables.txt
${PATH_BIN}iptables -I INPUT -p tcp -m tcpmss --mss 1:500 -j DROP
${PATH_BIN}ip6tables -I INPUT -p tcp -m tcpmss --mss 1:500 -j DROP
}




drop_v4_DNS_Tunneling() {
echo " > $FUNCNAME"
## NOT TESTED YET, but you can test :)
##  https://www.youtube.com/watch?v=q3dPih_8Cro
##  https://inside-out.xyz/technology/how-dns-tunneling-works.html

## For client
## The maximum value of characters for --log-prefix and --comment is 29.
COMMENT="-m comment --comment $FUNCNAME"
LOG="LOG --log-prefix IPTA:${FUNCNAME}:"
${PATH_BIN}iptables -I OUTPUT -p udp --dport 53 -m length --length 1025:65535 -j DROP $COMMENT
${PATH_BIN}iptables -I OUTPUT -p udp --dport 53 -m length --length 1025:65535 -j $LOG

${PATH_BIN}iptables -I OUTPUT -p udp --sport 53 -m length --length 1025:65535 -j DROP $COMMENT
${PATH_BIN}iptables -I OUTPUT -p udp --sport 53 -m length --length 1025:65535 -j $LOG

${PATH_BIN}iptables -I OUTPUT -p tcp --dport 53 -m length --length 1025:65535 -j DROP $COMMENT
${PATH_BIN}iptables -I OUTPUT -p tcp --dport 53 -m length --length 1025:65535 -j $LOG

${PATH_BIN}iptables -I OUTPUT -p tcp --sport 53 -m length --length 1025:65535 -j DROP $COMMENT
${PATH_BIN}iptables -I OUTPUT -p tcp --sport 53 -m length --length 1025:65535 -j $LOG
}




drop_v4_ddos() {
echo -e " > $FUNCNAME"
# PROTECTION BEFORE ATTACK Dos
# I don't know if it works 
${PATH_BIN}iptables -I INPUT -m conntrack --ctstate INVALID -p tcp ! --tcp-flags SYN,RST,ACK,FIN,PSH,URG SYN,RST \
-m comment --comment "protection before DDOS"
${PATH_BIN}iptables -N syn-flood \
-m comment --comment "protection before DDOS"
${PATH_BIN}iptables -I INPUT -p tcp --syn -j syn-flood \
-m comment --comment "protection before DDOS"
${PATH_BIN}iptables -I syn-flood -m limit --limit 1/s --limit-burst 4 -j RETURN \
-m comment --comment "protection before DDOS"
${PATH_BIN}iptables -I syn-flood -m limit --limit 1/s --limit-burst 4 -j LOG --log-prefix "IPTABLES: SYN-flood " \
-m comment --comment "protection before DDOS"
${PATH_BIN}iptables -I syn-flood -j DROP \
-m comment --comment "protection before DDOS"
}




drop_v4_ping_death() {
echo -e " > $FUNCNAME"
# PROTECTION BEFORE ATTACK PING OF DEATH 
# "To protect some really old equipment. For new devices probably is unnecessary."
# limits the number of pings 
${PATH_BIN}iptables -I INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT \
-m comment --comment "IPTABLES: drop_v4_ping_death "  

${PATH_BIN}iptables -I INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j LOG \
--log-prefix "IPTABLES: drop_v4_ping_death " -m comment --comment "IPTABLES: drop_v4_ping_death "
}




drop_v4_ping_death_v2() {
echo -e " > $FUNCNAME"
# PROTECTION BEFORE ATTACK PING OF DEATH 
# "To protect some really old equipment. For new devices probably is unnecessary."
${PATH_BIN}iptables -I INPUT -p icmp -f -j DROP \
-m comment --comment "IPTABLES: drop_v4_ping_death "  

${PATH_BIN}iptables -I INPUT -p icmp -f -j LOG \
--log-prefix "IPTABLES: drop_v4_ping_death " -m comment --comment "IPTABLES: drop_v4_ping_death "

# Yet another way 
#https://blacksaildivision.com/secure-iptables-rules-centos
}




drop_v4_fragments() {
echo -e " > $FUNCNAME"
# Packets with incoming fragments drop them.
${PATH_BIN}iptables -I INPUT -f -j DROP
${PATH_BIN}iptables -I INPUT -f -j LOG \
-m limit --limit 1/hour --limit-burst 1 \
--log-prefix "IPTABLES: drop_v4_fragments " -m comment --comment "IPTABLES: drop_v4_fragments"
}


#------------------DROP------------------}


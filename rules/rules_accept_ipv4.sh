#----------------------ACCEPT-----------------------------{






acpt4_desk_ftp_passive() {
    echo -e " > $FUNCNAME"
    ACCEPT="-j ACCEPT -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

#  lsmod | grep ip_tables
#  /sbin/modprobe ip_conntrack_ftp
#  https://unix.stackexchange.com/questions/93554/iptables-to-allow-incoming-ftp
#  https://www.cyberciti.biz/faq/iptables-passive-ftp-is-not-working/
#  http://slacksite.com/other/ftp.html#active
#  http://blog.hakzone.info/posts-and-articles/ftp/configure-iptables-to-support-ftp-passive-transfer-mode/
#  http://linuxforall.blogspot.com/2008/01/activepassive-ftp-iptables-firewall.html
#  https://unix.stackexchange.com/questions/93554/iptables-to-allow-incoming-ftp

# Client
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 21 -m conntrack --ctstate ESTABLISHED $ACCEPT
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 20 -m conntrack --ctstate ESTABLISHED,RELATED $ACCEPT
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 1024: --dport 1024: -m conntrack --ctstate ESTABLISHED $ACCEPT
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED $ACCEPT
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --dport 20 -m conntrack --ctstate ESTABLISHED $ACCEPT
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 1024:65535 --dport 1024:65535 -m conntrack --ctstate ESTABLISHED,RELATED $ACCEPT
}




acpt4_serv_ftp_passive() {
    echo -e " > $FUNCNAME"
    ACCEPT="-j ACCEPT -m comment --comment $FUNCNAME"
    LOG="-j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"

# serv
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED $ACCEPT
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --dport 20 -m conntrack --ctstate ESTABLISHED $ACCEPT
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 1024: --dport 1024: -m conntrack --ctstate ESTABLISHED,RELATED $ACCEPT
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 21 -m conntrack --ctstate ESTABLISHED $ACCEPT
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 20 -m conntrack --ctstate ESTABLISHED,RELATED $ACCEPT
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 1024:65535 --dport 1024:65535 -m conntrack --ctstate ESTABLISHED $ACCEPT
}




acpt4_serv_rsync() {
    echo -e " > $FUNCNAME"
    ACCEPT="-j ACCEPT -m comment --comment $FUNCNAME"
    LOG="  -j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"
    # ETH = interface from ifconfig like: lo, eth0 , eth1 , enp2s0 , wlp3s0
    ETH=""

${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp -m tcp --dport 873 -m state --state NEW,ESTABLISHED $LOG
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp        --sport 873 -m state --state ESTABLISHED     $LOG

${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp -m tcp --dport 873 -m state --state NEW,ESTABLISHED $ACCEPT
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp        --sport 873 -m state --state ESTABLISHED     $ACCEPT
}




acpt4_desk_rsync() {
    echo -e " > $FUNCNAME"
    ACCEPT="-j ACCEPT -m comment --comment $FUNCNAME"
    LOG="  -j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"
    # ETH = interface from ifconfig like: lo, eth0 , eth1 , enp2s0 , wlp3s0
    ETH=""

${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp -m tcp --dport 873 -m state --state ESTABLISHED     $LOG
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp        --sport 873 -m state --state NEW,ESTABLISHED $LOG

${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp -m tcp --dport 873 -m state --state ESTABLISHED     $ACCEPT
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp        --sport 873 -m state --state NEW,ESTABLISHED $ACCEPT
}




acpt4_serv_ssh() {
    echo -e " > $FUNCNAME"
    COMMENT="-m comment --comment $FUNCNAME"
    LOG="  -j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"
    # ETH = interface from ifconfig like: lo, eth0 , eth1 , enp2s0 , wlp3s0
    ETH=""

# accpt_serv_ssh = Accept incoming connection to SSH serv with stop Brute Force Attacks.
${PATH_BIN}iptables -N SSHSCAN  $COMMENT
${PATH_BIN}iptables -A INPUT -i $ETH -p tcp -m tcp --dport 22 -m state --state NEW -j SSHSCAN $COMMENT
${PATH_BIN}iptables -A SSHSCAN -m recent --set --name SSH --rsource $COMMENT
${PATH_BIN}iptables -A SSHSCAN -m recent --update --seconds 3600 --hitcount 5 --name SSH --rsource $LOG
${PATH_BIN}iptables -A SSHSCAN -m recent --update --seconds 3600 --hitcount 5 --name SSH --rsource -j LogDrp $COMMENT
${PATH_BIN}iptables -A SSHSCAN -j ACCEPT $COMMENT
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp -m tcp --dport 22 -m state --state ESTABLISHED -j SSHSCAN $COMMENT
#==============
# old rules
## ${PATH_BIN}iptables -A INPUT -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 -j REJECT
## ${PATH_BIN}iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
## ${PATH_BIN}iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j REJECT
##${PATH_BIN}iptables -A INPUT -m state --state NEW -p tcp --dport 22 -j ACCEPT

## ${PATH_BIN}iptables -A INPUT -p tcp --syn --dport 4444 -m connlimit --connlimit-above 3 -j REJECT
## ${PATH_BIN}iptables -A INPUT -p tcp --dport 4444 -m state --state NEW -m recent --set
## ${PATH_BIN}iptables -A INPUT -p tcp --dport 4444 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j REJECT
##${PATH_BIN}iptables -A INPUT -m state --state NEW -p tcp --dport 4444 -j ACCEPT
}




acpt4_serv_vnc() {
    echo -e " > $FUNCNAME"
    COMMENT="-m comment --comment $FUNCNAME"
    LOG="  -j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"
    # ETH = interface from ifconfig like: lo, eth0 , eth1 , enp2s0 , wlp3s0
    ETH=""

${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp --dport 5901 -m state --state NEW,ESTABLISHED $LOG
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 5901 -m state --state ESTABLISHED     $LOG

# accpt_vnc_for_serv = vnc ( SSH tunneling is safer )
${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp --dport 5901 -m state --state NEW,ESTABLISHED -j ACCEPT $COMMENT
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 5901 -m state --state ESTABLISHED     -j ACCEPT $COMMENT
}




acpt4_desk_vbox() {
    echo -e " > $FUNCNAME"
    ACCEPT="-j ACCEPT -m comment --comment $FUNCNAME"
    LOG="   -j LOG -m limit --limit 1/hour --limit-burst 1 --log-prefix IPT:${FUNCNAME}:"
    # ETH = interface from ifconfig like: lo, eth0 , eth1 , enp2s0 , wlp3s0
    ETH=""

${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp --sport 3389 -m state --state ESTABLISHED     $LOG
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 3389 -m state --state NEW,ESTABLISHED $LOG

# accpt_desk_vbox = Accept connection from virtualbox.
${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp --sport 3389 -m state --state ESTABLISHED     $ACCEPT
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 3389 -m state --state NEW,ESTABLISHED $ACCEPT
}




acpt4_desk_web_browser() {
    echo -e " > $FUNCNAME"
    # ETH = interface from ifconfig like: lo, eth0 , eth1 , enp2s0 , wlp3s0
    ETH=""

# accpt_desk_web_browser = Accept DNS HTTP HTTPS from web browser.
${PATH_BIN}iptables -A INPUT  -i $ETH -p udp --sport 53 -m state --state ESTABLISHED     -j ACCEPT \
-m comment --comment "acpt4_desk_web_browser_DNS" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "acpt4_desk_web_browser_DNS"

${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp --sport 80 -m state --state ESTABLISHED     -j ACCEPT \
-m comment --comment "acpt4_desk_web_browser_HTTP" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "acpt4_desk_web_browser_HTTP" 

${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp --sport 443 -m state --state ESTABLISHED     -j ACCEPT \
-m comment --comment "acpt4_desk_web_browser_HTTPS" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "acpt4_desk_web_browser_HTTPS" 
}




acpt4_desk_mail() {
    echo " > $FUNCNAME"
    # ETH = interface from ifconfig like: lo, eth0 , eth1 , enp2s0 , wlp3s0
    ETH=""

# more in https://support.linuxpl.com/Knowledgebase/Article/View/86/3/porty-dla-uslug-pocztowych-pop3-imap-smtp-oraz-ssl
# accpt_desk_mail_pop3 = Accept download messages with pop3 in e-mail
${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp --sport 995 -m state --state ESTABLISHED    -j ACCEPT \
-m comment --comment "acpt4_desk_mail_POP3" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 995 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "acpt4_desk_mail_POP3"

# accpt_desk_mail_smtp = Accept send messages with SMTP in e-mail
${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp --sport 465 -m state --state ESTABLISHED     -j ACCEPT \
-m comment --comment "acpt4_desk_mail_SMTP"
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 465 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "acpt4_desk_mail_SMTP" 
}




acpt4_desk_qtox() {
    echo " > $FUNCNAME"
    # ETH = interface from ifconfig like: lo, eth0 , eth1 , enp2s0 , wlp3s0
    ETH=""
    ACCEPT="-j ACCEPT -m comment --comment $FUNCNAME"

# accpt_desk_qtox = Accept connection from Qtox Instant Messaging.
${PATH_BIN}iptables -A INPUT  -i $ETH -p tcp --sport 33445 -m state --state ESTABLISHED     $ACCEPT
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 33445 -m state --state NEW,ESTABLISHED $ACCEPT
}




acpt4_desk_ntp() {

    echo " > $FUNCNAME"
    # ETH = interface from ifconfig like: lo, eth0 , eth1 , enp2s0 , wlp3s0
    ETH=""
    ACCEPT="-j ACCEPT -m comment --comment $FUNCNAME"

## Network Time Protocol
${PATH_BIN}iptables -A INPUT  -i $ETH -p udp -m state --state ESTABLISHED,RELATED --dport 123 $ACCEPT
${PATH_BIN}iptables -A OUTPUT -o $ETH -p udp -m udp --sport 123 $ACCEPT
}




acpt4_desk_printing() {
    echo -e " > $FUNCNAME"
    ACCEPT="-j ACCEPT -m comment --comment $FUNCNAME"

${PATH_BIN}iptables -A INPUT  -p udp -m udp --dport 631 $ACCEPT
${PATH_BIN}iptables -A INPUT  -p tcp -m tcp --dport 631 $ACCEPT
${PATH_BIN}iptables -A OUTPUT -p udp -m udp --sport 631 $ACCEPT
${PATH_BIN}iptables -A OUTPUT -p tcp -m tcp --sport 631 $ACCEPT
}




#accpt_GROUP() {
# https://unix.stackexchange.com/questions/68956/block-network-access-of-a-process/454767#454767
# Warning: I not tested, configure and test before permanent use.
# groupadd GROUP_NAME
# useradd -g GROUP_NAME USER_NAME
# then run app like this:
# sg GROUP_NAME APP_NAME

#   echo -e " > $FUNCNAME"

#${PATH_BIN}iptables -A OUTPUT -m owner --gid-owner GROUP_NAME   -j ACCEPT
#}






#----------------------ACCEPT-----------------------------}

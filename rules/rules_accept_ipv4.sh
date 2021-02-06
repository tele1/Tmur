#----------------------ACCEPT-----------------------------{

ETH=""

accept_desktop_ftp_passive() {
echo -e " > $FUNCNAME"

#  lsmod | grep ip_tables
#  /sbin/modprobe ip_conntrack_ftp
#  https://unix.stackexchange.com/questions/93554/${PATH_BIN}iptables-to-allow-incoming-ftp
#  https://www.cyberciti.biz/faq/${PATH_BIN}iptables-passive-ftp-is-not-working/
#  http://slacksite.com/other/ftp.html#active
#  http://blog.hakzone.info/posts-and-articles/ftp/configure-${PATH_BIN}iptables-to-support-ftp-passive-transfer-mode/
#  http://linuxforall.blogspot.com/2008/01/activepassive-ftp-${PATH_BIN}iptables-firewall.html
#  https://unix.stackexchange.com/questions/93554/${PATH_BIN}iptables-to-allow-incoming-ftp

# Client
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 21 -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "ftp client"
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 20 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment "ftp client"
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 1024: --dport 1024: -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "ftp client"
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT -m comment --comment "ftp client"
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --dport 20 -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "ftp client"
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 1024:65535 --dport 1024:65535 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment "ftp client"
}

accept_server_ftp_passive() {
echo -e " > $FUNCNAME"

# Server
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT -m comment --comment "ftp server"
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --dport 20 -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "ftp server"
${PATH_BIN}iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 1024: --dport 1024: -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment "ftp server"
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 21 -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "ftp server"
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 20 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment "ftp server"
${PATH_BIN}iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m tcp --sport 1024:65535 --dport 1024:65535 -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "ftp server"
}

accept_server_rsync() {
echo -e " > $FUNCNAME"
${PATH_BIN}iptables -A INPUT -i $ETH -p tcp -m tcp --dport 873 -m state --state NEW,ESTABLISHED -j ACCEPT -m comment --comment "server_rsync"
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --sport 873 -m state --state ESTABLISHED -j ACCEPT -m comment --comment "server_rsync"
}

accept_desktop_rsync() {
echo -e " > $FUNCNAME"
${PATH_BIN}iptables -A INPUT -i $ETH -p tcp -m tcp --dport 873 -m state --state ESTABLISHED -j ACCEPT -m comment --comment "desktop_rsync"
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --sport 873 -m state --state NEW,ESTABLISHED -j ACCEPT -m comment --comment "desktop_rsync"
}

accept_server_ssh() {
echo -e " > $FUNCNAME"
# accept_server_ssh = Accept incoming connection to SSH server with stop Brute Force Attacks.
${PATH_BIN}iptables -N SSHSCAN  -m comment --comment "server_ssh"
${PATH_BIN}iptables -A INPUT -i $ETH -p tcp -m tcp --dport 22 -m state --state NEW -j SSHSCAN -m comment --comment "server_ssh"
${PATH_BIN}iptables -A SSHSCAN -m recent --set --name SSH --rsource -m comment --comment "server_ssh"
${PATH_BIN}iptables -A SSHSCAN -m recent --update --seconds 3600 --hitcount 5 --name SSH --rsource -j LOG --log-prefix "accept_server_ssh" --log-level 6 -m comment --comment "server_ssh"
${PATH_BIN}iptables -A SSHSCAN -m recent --update --seconds 3600 --hitcount 5 --name SSH --rsource -j LogDrp -m comment --comment "server_ssh"
${PATH_BIN}iptables -A SSHSCAN -j ACCEPT -m comment --comment "server_ssh"
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp -m tcp --dport 22 -m state --state ESTABLISHED -j SSHSCAN -m comment --comment "server_ssh"
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

accept_server_vnc() {
echo -e " > $FUNCNAME"
# accept_vnc_for_server = vnc ( SSH tunneling is safer )
${PATH_BIN}iptables -A INPUT -i $ETH -p tcp --dport 5901 -m state --state NEW,ESTABLISHED -j ACCEPT \ 
-m comment --comment "accept_server_vnc" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 5901 -m state --state ESTABLISHED -j ACCEPT \
-m comment --comment "accept_server_vnc" 
}

accept_desktop_vbox() {
echo " > $FUNCNAME"
# accept_desktop_vbox = Accept connection from virtualbox.
${PATH_BIN}iptables -A INPUT -i $ETH -p tcp --sport 3389 -m state --state ESTABLISHED -j ACCEPT \
-m comment --comment "accept_desktop_vbox" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 3389 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "accept_desktop_vbox" 
}

accept_desktop_web_browser() {
echo " > $FUNCNAME"
# accept_desktop_web_browser = Accept DNS HTTP HTTPS from web browser.
${PATH_BIN}iptables -A INPUT -i $ETH -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT \
-m comment --comment "accept_web_browser , DNS" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "accept_web_browser , DNS" 

${PATH_BIN}iptables -A INPUT -i $ETH -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT \
-m comment --comment "accept_web_browser , HTTP" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "accept_web_browser , HTTP" 

${PATH_BIN}iptables -A INPUT -i $ETH -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT \
-m comment --comment "accept_web_browser , HTTPS" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "accept_web_browser , HTTPS" 
}

accept_desktop_mail() {
echo " > $FUNCNAME"
# more in https://support.linuxpl.com/Knowledgebase/Article/View/86/3/porty-dla-uslug-pocztowych-pop3-imap-smtp-oraz-ssl
# accept_desktop_mail_pop3 = Accept download messages with pop3 in e-mail
${PATH_BIN}iptables -A INPUT -i $ETH -p tcp --sport 995 -m state --state ESTABLISHED -j ACCEPT \
-m comment --comment "accept_mail_pop3" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 995 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "accept_mail_pop3" 

# accept_desktop_mail_smtp = Accept send messages with SMTP in e-mail
${PATH_BIN}iptables -A INPUT -i $ETH -p tcp --sport 465 -m state --state ESTABLISHED -j ACCEPT \
-m comment --comment "accept_mail_smtp" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 465 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "accept_mail_smtp" 
}

accept_desktop_qtox() {
echo -e " > $FUNCNAME"
# accept_desktop_qtox = Accept connection from Qtox Instant Messaging.
${PATH_BIN}iptables -A INPUT -i $ETH -p tcp --sport 33445 -m state --state ESTABLISHED -j ACCEPT \
-m comment --comment "accept_desktop_qtox" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p tcp --dport 33445 -m state --state NEW,ESTABLISHED -j ACCEPT \
-m comment --comment "accept_desktop_qtox" 
}

accept_desktop_ntp() {
echo -e " > $FUNCNAME"
${PATH_BIN}iptables -A INPUT -i $ETH -p udp -m state --state ESTABLISHED,RELATED --dport 123 -j ACCEPT \
-m comment --comment "accept__desktop_ntp" 
${PATH_BIN}iptables -A OUTPUT -o $ETH -p udp -m udp --sport 123 -j ACCEPT \
-m comment --comment "accept__desktop_ntp" 
}

accept_desktop_printing() {
echo -e " > $FUNCNAME"
${PATH_BIN}iptables -A INPUT -p udp -m udp --dport 631 -j ACCEPT \
-m comment --comment "accept__desktop_printing" 
${PATH_BIN}iptables -A INPUT -p tcp -m tcp --dport 631 -j ACCEPT \
-m comment --comment "accept__desktop_printing" 
${PATH_BIN}iptables -A OUTPUT -p udp -m udp --sport 631 -j ACCEPT \
-m comment --comment "accept__desktop_printing" 
${PATH_BIN}iptables -A OUTPUT -p tcp -m tcp --sport 631 -j ACCEPT \
-m comment --comment "accept__desktop_printing" 
}

#accept_GROUP() {
#echo -e " > $FUNCNAME"
# Warning: Rule Experimental, example config before use
# groupadd GROUP_NAME
# useradd -g GROUP_NAME USER_NAME
# then run app like this:
# sg GROUP_NAME APP_NAME
#echo "Warning: Rule Experimental and need config, read more in script"
#${PATH_BIN}iptables -A OUTPUT -m owner --gid-owner GROUP_NAME   -j ACCEPT
#}

accept_log_INPUT_and_OUTPUT() {
${PATH_BIN}iptables -A INPUT -j LOG --log-prefix "INPUT info:" --log-level 6
${PATH_BIN}iptables -A OUTPUT -j LOG --log-prefix "OUTPUT info:" --log-level 6
}

# Log lvl : http://fibrevillage.com/sysadmin/202-enable-linux-${PATH_BIN}iptables-logging
# Logging : https://tecadmin.net/enable-logging-in-${PATH_BIN}iptables-on-linux/

#----------------------ACCEPT-----------------------------}

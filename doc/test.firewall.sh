#!/bin/bash


## https://nmap.org/book/man-port-scanning-techniques.html


## localhost --> (127.0.0.1)
SCAN_IP="localhost"

## Scan all ports: -p- or -p0-65535
RANGE_OF_PORTS="-p0-65535"

cat  << EOF
    ##  These are examples
    ##  Copy, paste, edit, run to firewall check.
    ##  I suggest test with an open and closed port on localhost ;)
    ##  For example run commands in separate windows: 
    ##  || tail -f /var/log/syslog || tcpdump -i lo || nmap -v -sA -p0-2 localhost  ||
    ##  Pay attention to whether the lock is working (nmap output) 
    ##  and whether the event is logged (syslog)
    ##  and whether the rules of "iptables -S" are in the correct order.

## Scan all UDP and TCP ports
nmap -v -sU -sT ${RANGE_OF_PORTS} ${SCAN_IP}

## -sS (TCP SYN scan) 
nmap -v -sS ${RANGE_OF_PORTS} ${SCAN_IP}

## -sY (SCTP INIT scan) 
nmap -v -sY ${RANGE_OF_PORTS} ${SCAN_IP}

## Null scan (-sN)
nmap -v -sN ${RANGE_OF_PORTS} ${SCAN_IP}

## FIN scan (-sF)
nmap -v -sF ${RANGE_OF_PORTS} ${SCAN_IP}

## Xmas scan (-sX)
nmap -v -sX ${RANGE_OF_PORTS} ${SCAN_IP}

## -sA (TCP ACK scan) 
nmap -v -sA ${RANGE_OF_PORTS} ${SCAN_IP}

##  -sW (TCP Window scan) 
nmap -v -sW ${RANGE_OF_PORTS} ${SCAN_IP}

## -sM (TCP Maimon scan) 
nmap -v -sM ${RANGE_OF_PORTS} ${SCAN_IP}

## -sO (IP protocol scan) 
nmap -v -sO ${RANGE_OF_PORTS} ${SCAN_IP}

    ##  port states 
    ##  https://nmap.org/book/man-port-scanning-basics.html
    ##
    ##  " Well-known port numbers "
    ##  /etc/services
    ##  https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers


## OS detection
nmap -vvvv -O localhost


## Ping Scan
nmap -v -sn ${SCAN_IP}

## Ping Scan
ping -c4 ${SCAN_IP}

## Scan telnet port (port 23)
nmap -p 23 ${SCAN_IP}

## Monitor packets on eth1 interface (ifconfig)
tcpdump -i eth1

## Monitor packets <with details> <only numbers> <without checksum> <on eth1 interface> <on port 53>
tcpdump -vvvv -n -K -i enp2s0 'port 53'
EOF

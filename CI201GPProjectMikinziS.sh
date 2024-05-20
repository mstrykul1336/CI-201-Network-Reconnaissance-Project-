#!/bin/bash
#CI 201 Spring 2024 Group Project Mikinzi Strykul Section 02
#https://medium.com/@stefanos.kalandaridis/bash-ing-your-network-f7069ab7c5f4

#Main menu function using a case and select statements for the user to choose what function to do

MainMenu(){
#options array to store the options for the select statement

	options=("Ping Sweep" "Port Scan" "Print Scan Results" "Exit Program")
	
#print the mainmenu to screen

	echo "------ Main Menu ------"
	
#select statement of the choices from the options array

	select choice in "${options[@]}"; do
	
#case statement using the reply from the select statement to call the function that the user specified 
	
	case $REPLY in
	#call the function ping sweep 
	
		1) 
			PingSweep
			;;
	#call the function port scan
	
		2)
			PortScan
			;;
	#call the function printscanresults
	
		3)
			PrintScanResults
			;;
			
#exit function that uses exit 0 and prints that they are exiting

		4)
			echo "You are exiting the program!"
			exit 0
			;;
			
#error catching 

		*)
			echo "Invalid option! Try again."
			;;
			
	esac
	done
		
}
PingSweep(){
#echo the title of ping sweep 

	echo "------ Ping Sweep ------"
	
#enter in the date to the file 

	date >> pingresults.txt
	
#add another line for spacing	

	echo -e "\n"
#tell the user the instructions for how to enter the IP 

	echo "This will require you to enter the first three numbers in the sequence of the IPv4 address. For example, the first sequence in this IP, 172.30.40.16 is 172. The second sequence is 30. The third sequence is 40." 

#read in the number sequence the user provided for the IP

	read -p "Enter the first three number sequences of the IP Address: " IP1
	read -p "Enter the second three number sequences of the IP Address: " IP2
	read -p "Enter the third three number sequences of the IP Address: " IP3
	
#enter new line for spacing 

	echo -e "\n"
#start the loop for pinging the IPs and determining if they are active or not. Since there can only be 255, increment up to that.

	for x in {1..255}
	do
#echo what IP address is being pinged

		echo "IP Address: $IP1.$IP2.$IP3.$x is being pinged"
#ping with -c to limit the number of 1 ping to the host, -i to limit the ping to 1 millisecond, -w to wait for a response for 2 milliseconds.
#ping the IP given by the user, incrementing through the subnets using $x. Put all the extra terminal info in /dev/null abyss.

		ping -c 1 -i 1 -w 2 $IP1.$IP2.$IP3.$x &> /dev/null
		
#if we get an exit response, that means it found one!

		if [ "$?" = 0 ]
		then
#echo that it found the IP was reachable 
			echo "IP Address: $IP1.$IP2.$IP3.$x is reachable."
			
#put this into the pingresults.txt file

			echo "IP Address: $IP1.$IP2.$IP3.$x is reachable." >> pingresults.txt
		fi
			
	done
		
#call back to the main menu function when done

	MainMenu

}
PortScan(){

#echo the title of this function 

	echo "------- Port Scan -------"
	
#echo the date to the portscanresults.txt

	echo date >> portscanresults.txt
	
#add another line for spacing	

	echo -e "\n"
#tell the user the instructions for how to enter the IP 

	echo "This will require you to enter the first three numbers in the sequence of the IPv4 address. For example, the first sequence in this IP, 172.30.40.16 is 172. The second sequence is 30. The third sequence is 40. The fourth sequence is 16." 

#read in the number sequence the user provided for the IP

	read -p "Enter the first three number sequences of the IP Address: " IP1
	read -p "Enter the second three number sequences of the IP Address: " IP2
	read -p "Enter the third three number sequences of the IP Address: " IP3
	read -p "Enter the fourth three number sequences of the IP Address: " IP4
	
#enter new line for spacing 

	echo -e "\n"
	
	for port in {1..8888};
	do
	if (echo >/dev/tcp/$IP1.$IP2.$IP3.$IP4/$port) &>/dev/null; then
		echo "Port $port is open"
		echo "Port $port is open" >> portscanresults.txt
	fi
	done
	
	MainMenu
}

#this function will print scan results depending on the user choice for what they want to print. If they want to remove a file, there is that option or to return to the main menu.

PrintScanResults(){

#echo the print scan results title

	echo "------- Print Scan Results -------"
	
#create an array for the options in the case statement

	resultoptions=("Display Ping Sweep Results" "Display Port Scan Results" "Remove Ping Sweep Results file" "Remove Port Scan Results file" "Return to Main Menu")
	
	#use a select statement for the user selection of the choices
	
	select choice in "${resultoptions[@]}"; do
	
#case statement using the reply from the select statement to call the function that the user specified 

	case $REPLY in
	
#read the pingresults.txt file to screen

		1) 
			cat pingresults.txt 
			;;
			
#read the portscanresults.txt file to screen

		2)
			cat portscanresults.txt
			;;
			
#remove the pingresults.txt file

		3)
			rm pingresults.txt
			;;
			
#remove the portscanresults.txt file

		4)
			rm portscanresults.txt
			;;
			
#call back to the mainmenu

		5)
			MainMenu
			;;
			
#error catching 

		*)
			echo "Invalid option! Try again."
			;;
	esac
	done
}

#call mainmenu to start the program

MainMenu
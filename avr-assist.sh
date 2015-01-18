#!/bin/bash

## ------------------------------------------------------------
# A menu driven shell script for compiling and uploading AVR-C 
## ------------------------------------------------------------

RED='\033[0;41;30m'
STD='\033[0;0;39m'
 
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

# Compile 
one(){
	read_file
	echo "Compiling..."
	STRIPPEDFILENAME="${FILENAME%.*}";
	avr-gcc -w -Os -DF_CPU2000000UL -mmcu=atmega8 -c -o $STRIPPEDFILENAME\.o $FILENAME
	avr-gcc -w -mmcu=atmega8 $STRIPPEDFILENAME\.o -o $STRIPPEDFILENAME
	avr-objcopy -O ihex -R .eeprom $STRIPPEDFILENAME $STRIPPEDFILENAME\.hex
	rm $STRIPPEDFILENAME\.o $STRIPPEDFILENAME
        pause
}

#Compile and Upload
two(){
	read_file
	echo "Compiling...."
	STRIPPEDFILENAME="${FILENAME%.*}";
	avr-gcc -w -Os -DF_CPU2000000UL -mmcu=atmega8 -c -o $STRIPPEDFILENAME\.o $FILENAME
	avr-gcc -w -mmcu=atmega8 $STRIPPEDFILENAME\.o -o $STRIPPEDFILENAME
	avr-objcopy -O ihex -R .eeprom $STRIPPEDFILENAME $STRIPPEDFILENAME\.hex
	
	sudo avrdude -F -V -c avrispmkII -p ATmega8 -P usb -U flash:w:$STRIPPEDFILENAME\.hex
	rm $STRIPPEDFILENAME\.o $STRIPPEDFILENAME $STRIPPEDFILENAME\.hex
        pause
}
 
# Display Menu Funcion
show_menus() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "~ A V R - C O M P I L E R ~"
	echo "~~~~ M A I N - M E N U ~~~~"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Compile"
	echo "2. Compile & Upload"
	echo "3. Exit"
}

# Menu Options Function
read_options(){
	local choice
	read -p "Enter choice [ 1 - 3] " choice
	case $choice in
		1) one ;;
		2) two ;;
		3) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}

# Enter Filename Function
read_file(){
    local choice
    read -p "Enter filename: " choice
    FILENAME=$choice
}
 
trap '' SIGINT SIGQUIT SIGTSTP

# While loop to to display menu
while true
do
 
	show_menus
	read_options
done

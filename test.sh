#!/usr/bin/env bash

update_selected() {
	echo "Updating . . ."
	sudo apt update
	sudo apt-get update
	sudo apt upgrade -y
	sudo apt-get upgrade -y
	sudo apt autoremove -y
	sudo apt-get autoremove -y
	echo ""
	echo "System Updated"
	echo ""
}

configure_network_selected() {
	echo "Im configureing the network interface"
	sleep 1
}

configure_ssh_selected() {
	echo "Im configuring ssh"
	sleep 1
}

install_software_selected() {
	echo "Im installing software"
	sleep 1
}

full_stack_install_selected() {
	echo "im preparing a full stack installation"
	sleep 1
}

menu() {
	while [[ -z $server_name ]]
	do
		read -p "Who am I? " server_name
	done

	echo "My server name is: $server_name"
	sleep 1
	echo "What is my system type? "
	echo "1)Ubuntu-ML" "2)Ubuntu-Miner" "3)Ubuntu-Server" "4)Raspian-Desktop"
	echo "5)Raspian-LockCam" "6)Raspian-Console" "7)Raspian-Robot"

	until [[ $sys_type == [1-8] ]]; do
		read -p "Selection: " sys_type
	done

	echo "You selected: $sys_type"
}

main_menu() {
	main_menu_selection=0
        echo "Welcome to Lock Industries System Utility"
        echo "What would you like to do?"
        echo "1)Run Updates              2)Configure Network Interface"
        echo "3)Configure SSH            4)Install Software"
        echo "5)Full Stack Installation  6)Quit"
        until [[ $main_menu_selection == [1-6] ]]; do
                read -p "Selection: " main_menu_selection
        done

	case $main_menu_selection in
		1) update_selected; main_menu;;
		2) configure_network_selected; main_menu;;
		3) configure_ssh_selected; main_menu;;
		4) install_software_selected; main_menu;;
		5) full_stack_install_selected; main_menu;;
		6) echo "Exiting . . . "; sleep 1;;
	esac
}

main_menu
echo "End of line"
#if [[ $main_menu_selection -eq 5 ]]; then
#	menu
#fi
#echo "ok"


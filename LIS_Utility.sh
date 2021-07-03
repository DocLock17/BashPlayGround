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
	while [[ -z $server_name ]]
	do
		read -p "Who am I? " server_name
	done

	echo "My server name is: $server_name"
	sleep 1
}
# Needs fullfilled

configure_ssh_selected() {
	echo "Im configuring ssh"
	sleep 1
}
# Needs fullfilled

install_software_selected() {
	echo "Im installing software"
	sleep 1
}
# Needs fullfilled



install_ubuntu_dependencies() {
	echo "Installing Dependency"
	echo " "
}

install_ubuntu_utilities() {
	echo "Installing Utilities ..."
	echo " "
}

install_ubuntu_ml(){
	install_ubuntu_myStack() {
		install_ubuntu_dependencies
		echo "installing myStack"
		install_ubuntu_utilities
	}

	install_ubuntu_lambdaStack() {
		install_ubuntu_dependencies
		echo "installing LambdaStack"
		install_ubuntu_utilities
	}

	install_ubuntu_ml_selection=0
	echo ""
	echo "Select Stack Configuration"
	echo ""
	echo "1)Ubuntu-myStack   2)Ubuntu-LambdaStack"
	echo "3)Back to Menu"
	echo ""
	until [[ $install_ubuntu_ml_selection == [1-8] ]]; do
        	read -p "Selection: " install_ubuntu_ml_selection
    	done

	case $install_ubuntu_ml_selection in
		1) install_ubuntu_myStack;;
		2) install_ubuntu_lambdaStack;;
		3) echo "Exiting . . . "
	esac
}


install_ubuntu_miner(){
	install_ubuntu_ml
	echo " . . . NOW installing ubuntu miner"
}
# Needs fullfilled

install_ubuntu_server(){
	echo "Installing Ubuntu Server"
	install_ubuntu_dependencies
}



install_rpi_dependencies() {
	echo "Installing Dependency"
	echo " "
	sudo apt-get install software-properties-common build-essential cmake python3-dev libatlas-base-dev -y python3-pyqt5 libhdf5-dev libhdf5-103 libhdf5-dev -y
	echo " "
	sudo apt-get install libjpeg-dev libpng-dev libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev -y
	echo " "
	sudo apt-get install liblapack-dev libblas-dev libgirepository1.0-dev libpango1.0-dev libv4l-dev -y
	echo " "
	sudo apt-get install libx264-dev libtiff5-dev libfontconfig1-dev libcairo2-dev libgdk-pixbuf2.0-dev -y
	echo " "
	sudo apt-get install libgtk-3-dev libgtk2.0-dev libqtwebkit4 libqt4-test libgl1-mesa-glx libegl1-mesa -y
	echo " "
	sudo apt-get install libxtst6 libpango1.0-0 hdf5-tools gconf2-common gvfs-bin gfortran xclip -y 
}


install_rpi_utilities() {
	echo "Installing Utilities ..." &&
	echo " "
	sudo apt-get install nodejs npm screen hddtemp lm-sensors pv -y
	echo " "
	sudo python3 -m pip install --user --upgrade pip
	echo " "
	sudo python3 -m pip install --user virtualenv
}

install_rpi_desktop(){
	install_rpi_dependencies
	install_rpi_utilities
	echo "Installing RPi Desktop"
	Python3 -m venv env
	echo "Installing Virtual Environment ..." &&
	echo " " &&
	source env/bin/activate &&
	#echo " " >> ~/.bashrc &&
	echo "export PATH=/root/.local/bin:$PATH" >> ~/.bashrc &&
	echo " " &&
	echo "Adding virtual environment to the PATH ..." &&
	echo " " &&
	echo "Installing virtual environment resources ..." &&
	echo " " &&
	pip3 install -r setup/packagelist.txt &&
	echo " " &&
	echo "You will need to restart before changes can take effect ..." &&
	echo " " &&
	echo "Installation Complete!"
	echo ""
}
# Needs fullfilled

install_rpi_lockcam(){
	install_rpi_dependencies
	install_rpi_utilities
	echo "Installing RPi LockCam"
	Python3 -m venv env
	echo "Installing Virtual Environment ..." &&
	echo " " &&
	source env/bin/activate &&
	#echo " " >> ~/.bashrc &&
	echo "export PATH=/root/.local/bin:$PATH" >> ~/.bashrc &&
	echo " " &&
	echo "Adding virtual environment to the PATH ..." &&
	echo " " &&
	echo "Installing virtual environment resources ..." &&
	echo " " &&
	pip3 install -r setup/packagelist.txt &&
	echo " " &&
	pip3 install https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp37-cp37m-linux_armv7l.whl &&
	echo " " &&
	echo "You will need to restart before changes can take effect ..." &&
	echo " " &&
	echo "Installation Complete!"
	echo ""
}
# Needs fullfilled

install_rpi_console(){
	install_rpi_dependencies
	install_rpi_utilities
	echo "Installing RPi Console"
	Python3 -m venv env
	echo "Installing Virtual Environment ..." &&
	echo " " &&
	source env/bin/activate &&
	#echo " " >> ~/.bashrc &&
	echo "export PATH=/root/.local/bin:$PATH" >> ~/.bashrc &&
	echo " " &&
	echo "Adding virtual environment to the PATH ..." &&
	echo " " &&
	echo "Installing virtual environment resources ..." &&
	echo " " &&
	pip3 install -r setup/packagelist.txt &&
	echo " " &&
	echo "You will need to restart before changes can take effect ..." &&
	echo " " &&
	echo "Installation Complete!"
	echo ""
}
# Needs fullfilled

install_rpi_robot(){
	echo "installing rpi robot"
}
# Needs fullfilled



full_stack_install_selected() {
	stack_install_selection=0
	echo ""
	echo "Stack Installation Utility"
	echo ""
	echo "What is my system type? "
	echo ""
	echo "1)Ubuntu-ML        2)Ubuntu-Miner"
	echo "3)Ubuntu-Server    4)Raspian-Desktop"
	echo "5)Raspian-LockCam  6)Raspian-Console"
	echo "7)Raspian-Robot    8)Back to Menu"
	echo ""
	until [[ $stack_install_selection == [1-8] ]]; do
        	read -p "Selection: " stack_install_selection
	done

	case $stack_install_selection in
		1) install_ubuntu_ml;;
		2) install_ubuntu_miner;;
		3) install_ubuntu_server;;
		4) install_rpi_desktop;;
		5) install_rpi_lockcam;;
		6) install_rpi_console;;
		7) install_rpi_robot;;
		8) echo ""; echo "Exiting . . . "; sleep 1;;
	esac
}

main_menu() {
	main_menu_selection=0
	echo ""
	echo "Welcome to Lock Industries System Utility"
	echo ""
	echo "What would you like to do?"
	echo ""
	echo "1)Run Updates              2)Configure Network Interface"
	echo "3)Configure SSH            4)Install Software"
	echo "5)Full Stack Installation  6)Quit"
	echo ""
	until [[ $main_menu_selection == [1-6] ]]; do
        	read -p "Selection: " main_menu_selection
	done

	case $main_menu_selection in
		1) update_selected; main_menu;;
		2) configure_network_selected; main_menu;;
		3) configure_ssh_selected; main_menu;;
		4) install_software_selected; main_menu;;
		5) full_stack_install_selected; main_menu;;
		6) echo ""; echo "Exiting . . . "; sleep 1;;
	esac
}

main_menu
echo ""
echo "End of line"
echo "Push test"

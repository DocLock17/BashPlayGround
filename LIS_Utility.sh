#!/usr/bin/env bash

update_selected() {
	echo " "
	echo "Updating . . ."
	echo " "
	sudo apt update
	sudo apt-get update
	sudo apt upgrade -y --allow-downgrades
	sudo apt-get upgrade -y --allow-downgrades
	sudo apt autoremove -y
	sudo apt-get autoremove -y
	echo "System Updated"
	echo " "
}

# Fullfillment Needed
configure_network_selected() {
	echo "Im configureing the network interface"
	echo " "
	while [[ -z $server_name ]]
	do
		read -p "Who am I? " server_name
	done

	echo "My server name is: $server_name"
	echo " "
	sleep 1
}

# Fullfillment Needed
configure_ssh_selected() {
	echo "Im configuring ssh"
	echo " "
	sleep 1
}


install_software_selected() {
	install_retroPie(){
		update_selected
		# sudo apt install git lsb-release && \
		sudo apt install -y git dialog unzip xmlstarlet && \

		git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git && \

		cd RetroPie-Setup && \

		sudo ./retropie_setup.sh
	}
	install_software_sub=0
	echo "Select Software to install"
	echo ""
	echo "1)RetroPie       2)Atom"
	echo "3)Discord        4)Spotify"
	echo "5)Install All    6)Back to Menu"
	echo ""
	until [[ $install_software_sub == [1-2] ]]; do
        	read -p "Selection: " install_software_sub
    	done

	case $install_software_sub in
		1) install_retroPie;;
		2) snap install atom --classic;;
		3) snap install discord;;
		4) snap install spotify;;
		5) snap install atom --classic; snap install discord; snap install spotify; install_retroPie;;
		6) echo " "; echo "Exiting . . . "; echo " ";;
	esac
}

# Currently not in use
install_ubuntu_nvidiaDrivers() {
	update_selected
	# Install Basic Driver (unneeded!)
	#sudo apt-get install --no-install-recommends nvidia-driver-460 - y && \

	# Download and Install CUDA
	wget https://developer.download.nvidia.com/compute/cuda/11.2.0/local_installers/cuda-repo-ubuntu2004-11-2-local_11.2.0-460.27.04-1_amd64.deb && \

	# Install repository meta-data
	# sudo dpkg -i cuda-repo-<distro>_<version>_<architecture>.deb
	sudo dpkg -i cuda-repo-ubuntu2004-11-2-local_11.2.0-460.27.04-1_amd64.deb && \

	#When installing using network repo on Ubuntu 20.04/18.04
	sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub && \

	# Download and Add Nvidia Repository
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \sud
	sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \

	# Add Repo 
	sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" && \

	# Add CUDA to the PATH
	echo """
	# Nvidia 460+11.2 PATH
	export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}
	export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

	""" >> ~/.bashrc && \
	echo "" && \
	echo "Adding cuda-11.2 to the PATH ..." && \

	# Update Repositories
	sudo apt-get update && sudo apt update && \

	# Install CUDA
	sudo apt install cuda-toolkit-11-2 -y && \
	sudo apt install cuda -y
	echo " "
}

install_ubuntu_dependencies() {
	update_selected
	echo "Installing Dependencies"
	echo " "
	## Install Dependency Libraries and Utilities
	sudo apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 -y  

	sudo apt-get install curl gvfs gvfs-common gvfs-daemons gvfs-libs gconf-service gconf2 gconf2-common -y  

	## Install Node
	#sudo apt-get purge nodejs npm -y  
	curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
	sudo apt-get install -y nodejs

	sudo apt-get install gvfs-bin psmisc libpango1.0-0 node.js pciutils xclip xsel figlet cmake -y  
}

install_ubuntu_utilities() {
	update_selected
	echo "Installing Utilities ..."
	echo " "
	sudo apt-get install micro -y
	sudo apt-get install tilix -y
	sudo apt-get install net-tools -y 
	sudo apt-get install screen -y
	sudo apt-get install htop -y
	sudo apt-get install links2 -y
	sudo apt-get install elinks -y
	sudo apt-get install hddtemp -y
	sudo apt-get install lm-sensors -y
	sudo apt-get install pv -y
	echo " "
}

# Currently not in use
install_ubuntu_jupyter() {
	update_selected
	echo "Installing jupyter configuration ..." &&
	echo "" &&
	jupyter-lab --generate-config -y &&
	echo "c.JupyterApp.open_browser = False" >> /home/doclock17/.jupyter/jupyter_notebook_config.py &&
	echo "c.JupyterApp.allow_remote_access = True" >> /home/doclock17/.jupyter/jupyter_notebook_config.py &&
	#echo "c.JupyterApp.ip = '10.0.0.X'" >> /home/doclock17/.jupyter/jupyter_notebook_config.py &&
	echo "c.JupyterApp.ip = 'localhost'" >> /home/doclock17/.jupyter/jupyter_notebook_config.py &&
	echo "c.JupyterApp.port = 8888" >> /home/doclock17/.jupyter/jupyter_notebook_config.py &&
	echo "c.JupyterApp.password = ''" >> /home/doclock17/.jupyter/jupyter_notebook_config.py
	echo " "
}


install_ubuntu_ml(){
	install_ubuntu_myStack() {
		install_ubuntu_dependencies
		update_selected
		echo "Installing myStack"
		# Install Tools
		#sudo python3 -m pip install --upgrade pip  
		#echo ""  
		#sudo python3 -m pip install virtualenv  
		sudo apt-get install cmake -y
		sudo apt-get install python3-pip -y 
		sudo apt-get install python3-venv -y 

		# Create venv with ssp access
		python3 -m venv venv
		echo "Installing virtual environment ..." 
		source venv/bin/activate  

		# Add venv to the PATH
		echo """
		# Add venv PATH
		export PATH=/root/.local/bin:$PATH

		""" >> ~/.bashrc  
		echo ""  
		echo "Adding virtual environment to the PATH ..."  
		echo ""  
		echo "Installing virtual environment resources ..."  
		echo ""  

		# Installs the attached packagelist
		pip3 install -r myStack.txt

		# this may also help
		#pip3 install -r theplus.txt --ignore-installed
		#python -m ipykernel install --user --name=venv
		#python -m pip install jupyter

		install_ubuntu_utilities
		echo " "
	}

	install_ubuntu_lambdaStack() {
		install_ubuntu_dependencies
		update_selected
		echo "Installing LambdaStack"
		echo " "
		# Add Lambda Repository
		LAMBDA_REPO=$(mktemp)  
		wget -O${LAMBDA_REPO} https://lambdalabs.com/static/misc/lambda-stack-repo.deb  
		sudo dpkg -i ${LAMBDA_REPO} && rm -f ${LAMBDA_REPO}  

		# Update Repositories
		sudo apt update && sudo apt-get update  

		# Install Lambda Stack
		sudo apt-get install -y lambda-stack-cuda -y

		sudo apt-get install python3-pip -y  
		echo ""  
		sudo apt-get install python3-venv -y  
		echo ""  

		# Create venv with ssp access
		python3 -m venv venv --system-site-packages   
		#--system-site-packages  
		echo ""  
		echo "Installing virtual environment ..."  
		echo ""  
		source venv/bin/activate  

		# Add venv to the PATH
		echo """
		# Add venv PATH
		export PATH=/root/.local/bin:$PATH

		""" >> ~/.bashrc 
		echo ""  
		echo "Adding virtual environment to the PATH ..."  
		echo ""  
		echo "Installing virtual environment resources ..."  
		echo ""  

		# Installs the attached packagelist
		python -m ipykernel install --user --name=venv
		pip3 install -r myPlus.txt --ignore-installed
		install_ubuntu_utilities
		echo " "
	}

	install_ubuntu_anacondaStack() {
		install_ubuntu_dependencies
		update_selected
		echo "installing AnacondaStack"
		install_ubuntu_utilities
		echo " "
	}

	install_ubuntu_ml_selection=0
	echo ""
	echo "Select Stack Configuration"
	echo ""
	echo "1)Ubuntu-myStack         2)Ubuntu-LambdaStack"
	echo "3)Ubuntu-anacondaStack   4)Exit Without Installing"
	echo ""
	until [[ $install_ubuntu_ml_selection == [1-4] ]]; do
        	read -p "Selection: " install_ubuntu_ml_selection
    	done

	case $install_ubuntu_ml_selection in
		1) install_ubuntu_myStack;;
		2) install_ubuntu_lambdaStack;;
		3) install_ubuntu_anacondaStack;;
		4) echo " "; echo "Exiting . . . "; echo " ";;
	esac
}

install_ubuntu_miner(){
	install_ubuntu_ml
	update_selected
	echo "Installing Cudo Miner"
	sudo su -c "bash <( wget -qO- https://download.cudo.org/tenants/135790374f46b0107c516a5f5e13069b/5e5f800fdf87209fdf8f9b61441e53a1/linux/x64/stable/install.sh )"
	echo " "
}

install_ubuntu_server(){
	echo "Installing Ubuntu Server"
	install_ubuntu_dependencies
	update_selected
	install_ubuntu_utilities
	echo " "
}



# Testing Needed
install_rpi_dependencies() {
	update_selected
	echo " "
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
	echo " "
}

# Testing Needed
install_rpi_utilities() {
	update_selected
	echo "Installing Utilities ..." &&
	echo " "
	sudo apt-get install nodejs npm  tilix  figlet screen links2 elinks hddtemp lm-sensors pv -y
	echo " "
	sudo apt-get install nodejs npm screen hddtemp lm-sensors pv -y
	echo " "
	sudo python3 -m pip install --user --upgrade pip
	echo " "
	sudo python3 -m pip install --user virtualenv
	echo " "
}

# Testing Needed
install_rpi_jupyter() {
	update_selected
	echo "Installing jupyter configuration ..." &&
	echo "" &&
	jupyter-lab --generate-config -y &&
	echo "c.JupyterApp.open_browser = False" >> /home/pi/.jupyter/jupyter_notebook_config.py &&
	echo "c.JupyterApp.allow_remote_access = True" >> /home/pi/.jupyter/jupyter_notebook_config.py &&
	#echo "c.JupyterApp.ip = '10.0.0.X'" >> /home/pi/.jupyter/jupyter_notebook_config.py &&
	echo "c.JupyterApp.ip = 'localhost'" >> /home/pi/.jupyter/jupyter_notebook_config.py &&
	echo "c.JupyterApp.port = 8888" >> /home/pi/.jupyter/jupyter_notebook_config.py &&
	echo "c.JupyterApp.password = ''" >> /home/pi/.jupyter/jupyter_notebook_config.py
	echo " "
}

# Testing Needed
install_rpi_desktop(){
	install_rpi_dependencies
	install_rpi_utilities
	update_selected
	echo " "
	echo "Installing RPi Desktop"
	python3 -m venv env
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
	install_rpi_jupyter
	echo "You will need to restart before changes can take effect ..." &&
	echo " " &&
	echo "Installation Complete!"
	echo ""
}

# Testing Needed
install_rpi_lockcam(){
	install_rpi_dependencies
	install_rpi_utilities
	update_selected
	echo " "
	echo "Installing RPi LockCam"
	echo " "
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

# Testing Needed
install_rpi_console(){
	install_rpi_dependencies
	install_rpi_utilities
	update_selected
	echo " "
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

# Testing Needed
install_rpi_robot(){
	install_rpi_dependencies
	install_rpi_utilities
	update_selected
	echo " "
	echo "Installing RPi Robot"
	# Bot Specific?
	# sudo pip3 install pillow
	# sudo pip3 install numpy
	sudo apt-get install libopenjp2-7 -y &&
	#sudo apt install libtiff -y &&
	sudo apt install libtiff5 -y &&
	# sudo apt-get install libatlas-base-dev
	# sudo apt-get install python3-pip
	# sudo pip3 install RPi.GPIO
	install_rpi_jupyter
}



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
		8) echo ""; echo "Exiting . . . "; echo " ";;
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
		6) echo ""; echo "Exiting . . . "; echo " ";;
	esac
}

main_menu
echo ""
echo "sudo apt-get update && sudo apt-get upgrade -y  && sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo reboot now"
echo ""
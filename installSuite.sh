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

# Testing Needed
configure_network_selected() {
	echo " "
	echo "Now configureing Network Interface"
	echo " "

	while [[ -z $server_number ]]
	do
		read -p "Input Unit Number: " server_number
	done
	#echo "Unit Number is: $server_number"

	while [[ -z $server_name ]]
	do
		read -p "Input Unit Name: " server_name
	done
	#echo "Unit Name is: $server_name"

	my_hostname="LIS"$server_number"-"$server_name

	echo "Hostname will be changed to: $my_hostname in 3 seconds"; echo ""
	sleep 1

	echo "3"; echo ""
	sleep 1

	echo "2"; echo ""
	sleep 1

	echo "1"; echo ""
	sleep 1

	echo "$my_hostname" > /etc/hostname
	echo "Hostname is now: $my_hostname"; echo ""

	#### Helpful Hints
	#to get external ip
	#global_ip=`wget -qO- ipecho.net/plain`
	#echo global_ip

	# to get local ip
	# ip a s wlo1 | awk '/inet / {print$2}'|cut -d/ -f1
	
	# to get local mask
	# ip a s wlo1 | awk '/inet / {print$2}'|cut -d/ -f2

	# to get ip leader
	#ip a s wlo1 | awk '/inet / {print$2}'|cut -d. -f1-3

	# Show all interface names:
	# ip link | awk -F: '$0 ~ "en|et|wl|^[^0-9]"{print $2a;getline}'

	# Show current interface name (might be deprecated soon)
	# ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//"
	# also
	# ip route get 8.8.8.8 | awk -- '{printf $5}'

	#### Will Create this
	# sudo nano /etc/netplan/99_config.yaml

	# network:
	#   version: 2
	#   renderer: networkd
	#   ethernets:
	#     wlo1:
	#       addresses:
	#         - 10.0.0.25/24
	#       gateway4: 10.0.0.1
	#       nameservers:
	#           search: [mydomain, otherdomain]
	#           addresses: [10.0.0.1, 8.8.8.8, 7.7.7.7]

	# sudo netplan apply

	interface_name=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")
	ip_leader=$(hostname -I | cut -d. -f1-3)
	ip_suffix=$(ip a s $interface_name | awk '/inet / {print$2}'|cut -d/ -f2)
	new_ip=$ip_leader"."$server_number
	ip_string=$new_ip"/"$ip_suffix
	
	echo "Local IP Address on $interface_name will be changed to: $new_ip in 5 seconds"; echo ""
	sleep 1

	echo "5"; echo ""
	sleep 1

	echo "4"; echo ""
	sleep 1

	echo "3"; echo ""
	sleep 1

	echo "2"; echo ""
	sleep 1

	echo "1"; echo ""
	sleep 1

	echo "" > /etc/netplan/99_config.yaml
	echo "network:" >> /etc/netplan/99_config.yaml
	echo "    version: 2" >> /etc/netplan/99_config.yaml
	echo "    renderer: networkd" >> /etc/netplan/99_config.yaml
	echo "    ethernets:" >> /etc/netplan/99_config.yaml
	echo "      $interface_name:" >> /etc/netplan/99_config.yaml
	echo "        addresses:" >> /etc/netplan/99_config.yaml
	echo "          - $ip_string" >> /etc/netplan/99_config.yaml
	echo "        gateway4: $ip_leader.1" >> /etc/netplan/99_config.yaml
	echo "        nameservers:" >> /etc/netplan/99_config.yaml
	echo "          search: [mydomain, otherdomain]" >> /etc/netplan/99_config.yaml
	echo "          addresses: [$ip_leader.1, 8.8.8.8, 7.7.7.7]" >> /etc/netplan/99_config.yaml
	sudo netplan apply
	echo "Local IP Address is now: $new_ip"; echo ""
}


# Fullfillment Needed
configure_ssh_selected() {
	echo "Configuring SSH"
	echo " "
	update_selected
	sudo apt-get install openssh-server -y
	sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
	sudo chmod a-w /etc/ssh/sshd_config.factory-defaults

	#### Settings you might want to change
	#Port 22
	#AddressFamily any
	#ListenAddress 0.0.0.0
	#ListenAddress ::

	#HostKey /etc/ssh/ssh_host_rsa_key
	#HostKey /etc/ssh/ssh_host_ecdsa_key
	#HostKey /etc/ssh/ssh_host_ed25519_key
	#AuthorizedKeysFile     .ssh/authorized_keys

	#AllowTcpForwarding yes
	#X11Forwarding yes
	#AllowUsers doclock17" >> /etc/ssh/sshd_config
	#LogLevel VERBOSE" >> /etc/ssh/sshd_config

	#MaxSessions 10
	#PasswordAuthentication yes

	echo "MaxSessions 5" >> /etc/ssh/sshd_config
	echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config
	echo "LogLevel VERBOSE" >> /etc/ssh/sshd_config
	echo "AllowUsers doclock17" >> /etc/ssh/sshd_config

	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
	
	# This doesn't work with MAC :(
	#echo "HostKey /home/doclock17/Desktop/SSH_KEYS/SSH_KEYS" >> /etc/ssh/sshd_config
	#echo "AuthorizedKeysFile /home/doclock17/Desktop/SSH_KEYS/SSH_KEYS.pub" >> /etc/ssh/sshd_config

	echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
	echo "Welcome Back Dr.Locker " >> /etc/issue.net

	sleep 1
	#sudo restart ssh
	sudo systemctl restart ssh
	echo ""
	echo "Don't forget to generate rsa keys on client system using:"
	echo "ssh-keygen -t rsa"
	echo ""
	echo "Then send the keys here using:"
	echo "ssh-copy-id -i ~/.ssh/id_rsa.pub doclock17@" $(hostname -I | cut -d. -f1-4)
	echo ""
	echo "Then shut-off password authentication:"
	echo "sudo nano /etc/ssh/sshd_config"
	echo "sudo systemctl restart ssh"

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
	echo "5)Google Chrome  6)Install All"
	echo "7)Back to Menu"
	echo ""
	until [[ $install_software_sub == [1-7] ]]; do
        	read -p "Selection: " install_software_sub
    	done

	case $install_software_sub in
		1) install_retroPie;;
		2) snap install atom --classic;;
		3) snap install discord;;
		4) snap install spotify;;
		5) wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; sudo apt install ./google-chrome-stable_current_amd64.deb;;
		6) snap install atom --classic; snap install discord; snap install spotify; install_retroPie; wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; sudo apt install ./google-chrome-stable_current_amd64.deb;;
		7) echo " "; echo "Exiting . . . "; echo " ";;
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

	sudo apt install xfce4 xfce4-goodies -y
	
	sudo apt-get install -y nodejs 

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
	sudo apt install tightvncserver
	echo " "
}

# Currently not in use
install_ubuntu_jupyter() {
	update_selected
	echo "Installing jupyter configuration ..."
	pip install jupyter
	pip install jupyterlab
	#pip3 install jupyter
	#pip3 install jupyterlab
	echo ""
	jupyter-lab --generate-config -y
	echo "# My Jupyter Config: " >> /home/doclock17/.jupyter/jupyter_lab_config.py
	echo "c.JupyterApp.open_browser = False" >> /home/doclock17/.jupyter/jupyter_lab_config.py
	echo "c.ServerApp.allow_remote_access = True" >> /home/doclock17/.jupyter/jupyter_lab_config.py
	#echo "c.ServerApp.ip = '10.0.0.X'" >> /home/doclock17/.jupyter/jupyter_lab_config.py &&
	echo "c.ServerApp.ip = 'localhost'" >> /home/doclock17/.jupyter/jupyter_lab_config.py
	echo "c.ServerApp.port = 8888" >> /home/doclock17/.jupyter/jupyter_lab_config.py
	echo "c.ServerApp.password = ''" >> /home/doclock17/.jupyter/jupyter_lab_config.py
	echo "Jupyter Lab Configured"
	echo " "
	jupyter-notebook --generate-config -y
	echo "# My Jupyter Config: " >> /home/doclock17/.jupyter/jupyter_notebook_config.py
	echo "c.JupyterApp.open_browser = False" >> /home/doclock17/.jupyter/jupyter_notebook_config.py
	echo "c.ServerApp.allow_remote_access = True" >> /home/doclock17/.jupyter/jupyter_notebook_config.py
	#echo "c.ServerApp.ip = '10.0.0.X'" >> /home/doclock17/.jupyter/jupyter_notebook_config.py &&
	echo "c.ServerApp.ip = 'localhost'" >> /home/doclock17/.jupyter/jupyter_notebook_config.py
	echo "c.ServerApp.port = 8888" >> /home/doclock17/.jupyter/jupyter_notebook_config.py
	echo "c.ServerApp.password = ''" >> /home/doclock17/.jupyter/jupyter_notebook_config.py
	echo "Jupyter Notebook Configured"
	echo " "
}


install_ubuntu_ml(){
	install_ubuntu_myStack() {
		install_ubuntu_dependencies
		update_selected
		install_ubuntu_utilities
		update_selected
		install_ubuntu_nvidiaDrivers
		update_selected
		#gsettings set org.gnome.desktop.background picture-uri file:////home/doclock17/Github/Doclock17/BashPlayGround/automaticWallpaper/smartBulb.png
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
		install_ubuntu_jupyter
		echo " "
	}

	install_ubuntu_lambdaStack() {
		install_ubuntu_dependencies
		update_selected
		install_ubuntu_utilities
		update_selected
		echo "Installing LambdaStack"
		echo " "

		# # Add Lambda Repository
		# LAMBDA_REPO=$(mktemp)  
		# wget -O${LAMBDA_REPO} https://lambdalabs.com/static/misc/lambda-stack-repo.deb  
		# sudo dpkg -i ${LAMBDA_REPO} && rm -f ${LAMBDA_REPO}  
		# # Update Repositories
		# sudo apt update && sudo apt-get update  
		# # Install Lambda Stack
		# sudo apt-get install -y lambda-stack-cuda -y

		LAMBDA_REPO=$(mktemp) && \
		wget -O${LAMBDA_REPO} https://lambdalabs.com/static/misc/lambda-stack-repo.deb && \
		sudo dpkg -i ${LAMBDA_REPO} && rm -f ${LAMBDA_REPO} && \
		sudo apt-get update && \
		sudo apt-get --yes upgrade && \
		echo "cudnn cudnn/license_preseed select ACCEPT" | sudo debconf-set-selections && \
		sudo apt-get install --yes --no-install-recommends lambda-server && \
		sudo apt-get install --yes --no-install-recommends nvidia-450 libcuda1-450 nvidia-opencl-icd-450 && \
		sudo apt-get install --yes --no-install-recommends lambda-stack-cuda

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
		#install_ubuntu_jupyter
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
	echo "3)Exit Without Installing" #Ubuntu-anacondaStack   4)
	echo ""
	until [[ $install_ubuntu_ml_selection == [1-3] ]]; do
        	read -p "Selection: " install_ubuntu_ml_selection
    	done

	case $install_ubuntu_ml_selection in
		1) install_ubuntu_myStack;;
		2) install_ubuntu_lambdaStack;;
		3) echo " "; echo "Exiting . . . "; echo " ";;
		#install_ubuntu_anacondaStack;; #4)
	esac
}

install_ubuntu_miner(){
	install_ubuntu_ml
	update_selected
	echo "Installing Cudo Miner"
	sudo su -c "bash <( wget -qO- https://download.cudo.org/tenants/135790374f46b0107c516a5f5e13069b/5e5f800fdf87209fdf8f9b61441e53a1/linux/x64/stable/install.sh )"
	#gsettings set org.gnome.desktop.background picture-uri file:////home/doclock17/Github/Doclock17/BashPlayGround/automaticWallpaper/inyabackground.png
	echo " "
}

install_ubuntu_server(){
	echo "Installing Ubuntu Server"
	install_ubuntu_dependencies
	update_selected
	install_ubuntu_utilities
	echo " "
}




install_rpi_dependencies() {
	update_selected
	echo " "
	echo "Installing Dependencies"
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

install_rpi_utilities() {
	update_selected
	echo "Installing Utilities ..."
	echo " "
	sudo apt-get install nodejs npm  tilix  figlet screen links2 elinks hddtemp lm-sensors pv -y
	echo " "
	sudo apt-get install nodejs npm screen hddtemp lm-sensors pv -y
	echo " "
	sudo python3 -m pip install --user --upgrade pip
	echo " "
	sudo python3 -m pip install --user virtualenv
	echo " "
	python3 -m venv env
	echo "Installing Virtual Environment ..."
	echo " "
	source env/bin/activate
	#echo " " >> ~/.bashrc &&
	echo "export PATH=/root/.local/bin:$PATH" >> ~/.bashrc
	echo "Adding virtual environment to the PATH ..."
	echo " "
	echo "Installing virtual environment resources ..."
	echo " "
	pip3 install -r packagelist.txt
	echo " "
}


install_rpi_jupyter() {
	update_selected
	echo "Installing jupyter configuration ..."
	pip install nodejs
	pip install jupyter
	pip install jupyterlab
	#pip3 install jupyter
	#pip3 install jupyterlab
	echo ""
	jupyter-lab --generate-config -y
	echo "# My Jupyter Config: " >> /home/pi/.jupyter/jupyter_lab_config.py
	echo "c.JupyterApp.open_browser = False" >> /home/pi/.jupyter/jupyter_lab_config.py
	echo "c.ServerApp.allow_remote_access = True" >> /home/pi/.jupyter/jupyter_lab_config.py
	#echo "c.ServerApp.ip = '10.0.0.X'" >> /home/pi/.jupyter/jupyter_lab_config.py &&
	echo "c.ServerApp.ip = 'localhost'" >> /home/pi/.jupyter/jupyter_lab_config.py
	echo "c.ServerApp.port = 8888" >> /home/pi/.jupyter/jupyter_lab_config.py
	echo "c.ServerApp.password = ''" >> /home/pi/.jupyter/jupyter_lab_config.py
	echo "Jupyter Lab Configured"
	echo " "
	jupyter-notebook --generate-config -y
	echo "# My Jupyter Config: " >> /home/pi/.jupyter/jupyter_notebook_config.py
	echo "c.JupyterApp.open_browser = False" >> /home/pi/.jupyter/jupyter_notebook_config.py
	echo "c.ServerApp.allow_remote_access = True" >> /home/pi/.jupyter/jupyter_notebook_config.py
	#echo "c.ServerApp.ip = '10.0.0.X'" >> /home/pi/.jupyter/jupyter_notebook_config.py &&
	echo "c.ServerApp.ip = 'localhost'" >> /home/pi/.jupyter/jupyter_notebook_config.py
	echo "c.ServerApp.port = 8888" >> /home/pi/.jupyter/jupyter_notebook_config.py
	echo "c.ServerApp.password = ''" >> /home/pi/.jupyter/jupyter_notebook_config.py
	echo "Jupyter Notebook Configured"
	echo " "
}

# Testing Needed
install_rpi_desktop(){
	install_rpi_dependencies
	install_rpi_utilities
	update_selected
	echo " "
	echo "Installing RPi Desktop"
	echo " "
	install_rpi_jupyter
	echo "You will need to restart before changes can take effect ..."
	echo " "
	echo "Installation Complete!"
	echo ""
}

# Testing Needed
install_rpi_lockcam(){
	install_rpi_dependencies
	install_rpi_utilities
	update_selected
	install_rpi_jupyter
	echo " "
	echo "Installing RPi LockCam"
	echo " "
	pip3 install https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp37-cp37m-linux_armv7l.whl
	echo " "
	echo "You will need to restart before changes can take effect ..."
	echo " "
	echo "Installation Complete!"
	echo ""
}

# Testing Needed
install_rpi_console(){
	install_rpi_dependencies
	install_rpi_utilities
	update_selected
	install_rpi_jupyter
	echo " "
	echo "Installing RPi Console"
	echo " "
	echo "You will need to restart before changes can take effect ..."
	echo " "
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
	sudo apt-get install libopenjp2-7 -y
	#sudo apt install libtiff -y &&
	sudo apt install libtiff5 -y
	# sudo apt-get install libatlas-base-dev
	# sudo apt-get install python3-pip
	# sudo pip3 install RPi.GPIO
	install_rpi_jupyter
	echo "Done"
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
echo "sudo apt-get update && sudo apt-get upgrade -y  && sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt-get autoremove -y && sudo reboot now"

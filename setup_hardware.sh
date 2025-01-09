# Hardware setup functions

setup_camera_csi()
{
	read -p "Function not yet available, press enter to continue"
}

setup_camera_usb()
{
	read -p "Function not yet available, press enter to continue"
}

setup_sense_hat()
{
	apt-get -y install sense-hat
	sed -i 's/#dtparam=i2c_arm=on/dtparam=i2c_arm=on/g' /boot/firmware/config.txt
 	# Install cli calibration
	wget -O RTIMULib.zip https://github.com/RPi-Distro/RTIMULib/archive/master.zip
	unzip RTIMULib.zip
	cd RTIMULib-master/Linux/RTIMULibCal
	make
	make install
	cd /home/$usrname
	rm -rf RTIMULib*
 	read -p "Sense-hat setup complete, press enter to continue"
}

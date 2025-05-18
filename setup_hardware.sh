# Hardware setup functions

setup_camera_csi()
{
	apt-get -y install python3-picamera2 --no-install-recommends
	read -p "Camera setup done, press enter to continue"
}

setup_camera_usb()
{
	read -p "Function not yet available, press enter to continue"
}

setup_i2c()
{
	apt-get install i2c-tools python3-smbus gpiod
	sed -i 's/#dtparam=i2c_arm=on/dtparam=i2c_arm=on/g' /boot/firmware/config.txt
 	echo "i2c-dev" >> /etc/modules
}

setup_sense_hat()
{
	apt-get -y install sense-hat
	sed -i 's/#dtparam=i2c_arm=on/dtparam=i2c_arm=on/g' /boot/firmware/config.txt
 	echo "i2c-dev" >> /etc/modules
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

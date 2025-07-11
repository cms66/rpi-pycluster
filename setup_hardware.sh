# Hardware setup functions

setup_pcie()
{
	# Enable
 	echo "dtparam=pciex1" >> /boot/firmware/config.txt
	echo "dtparam=pciex1_gen=3" >> /boot/firmware/config.txt
}

setup_camera_csi()
{
	apt-get -y install python3-picamera2 --no-install-recommends
 	# TODO
  	# Check RPi model (Pi5/CM5 dual camera)
   	# Get Camera model
   	# Modify /boot/firmware/config.txt
    	echo "dtoverlay=imx219,cam0" >> /boot/firmware/config.txt
    	# Fix non-sudo access
    	echo "SUBSYSTEM==\"dma_heap\", GROUP=\"video\", MODE=\"0660\"" >> /etc/udev/rules.d/raspberrypi.rules
     	udevadm control --reload-rules && udevadm trigger
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

setup_gps()
{
	# TODO git clone https://github.com/pimoroni/pa1010d-python + install not working
 	# Temp fix - Install to venv as user - installs pynmea2
  	# cp -r .venv/lib/python3.11/site-packages/pynmea2 /lib/python3.11/
   	# 
	read -p "Function not yet available, press enter to continue"
}

setup_hailo()
{
	apt-get install hailo-all
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

# Bash functions

# Install/update software
update_system()
{
	printf "%s\n" "Updating system"
	apt-get -y update
	apt-get -y upgrade
	apt-get -y install python3-dev gcc g++ gfortran libraspberrypi-dev libomp-dev git-core build-essential cmake pkg-config make screen htop stress-ng zip bzip2 fail2ban ufw ntpdate pkgconf openssl
 	# Remove local SDM
  	rm -rf /usr/local/sdm
 	rm -rf /usr/local/bin/sdm
  	rm -rf /etc/sdm
  printf "%s\n" "System update complete"
}

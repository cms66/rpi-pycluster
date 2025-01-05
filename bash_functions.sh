# Bash functions

# Error handling
set -e
# Error handler
handle_error()
{
	echo "Error: $(caller) : ${BASH_COMMAND}"
}
# Set the error handler to be called when an error occurs
trap handle_error ERR

# Install/update software
update_system_base()
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

setup_ntp()
{
	printf "%s\n" "Configuring ntp"
 	sed -i "s/#FallbackNTP/FallbackNTP/g" /etc/systemd/timesyncd.conf # Setup NTP
  printf "%s\n" "ntp setup complete"
}

install_munge_local()
{
	# Create System group and user
	# Check uid/guid/user available
	defid=991
	getent passwd $defid && mnguid=$? # 0 = uid exists
	getent group $defid && mnggid=$? # 0 = guid exists
	getent passwd munge && mngusr=$? # 0 = uid exists
	if [[ $mnguid ]] || [[ $mnggid ]] || [[ $mngusr ]]; then # uid/guid/user exists
		read -p "UID, GUID or user exists"
		return
	else
		#read -p "UID and GUID available"
		groupadd -r -g $defid munge
		useradd -r -c "MUNGE Uid 'N' " -g munge -u $defid -d /var/lib/munge -s /sbin/nologin munge
		apt-get -y install libmunge-dev munge
		
	fi
    read -p "Munge install done"
}

update_system_base
setup_ntp
install_munge_local

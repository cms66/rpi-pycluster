# Bash functions

# Set default shell to bash
set_default_shell()
{
  printf "%s\n" "Setting shell to bash"
	dpkg-divert --remove --no-rename /usr/share/man/man1/sh.1.gz
	dpkg-divert --remove --no-rename /bin/sh
	ln -sf bash.1.gz /usr/share/man/man1/sh.1.gz
	ln -sf bash /bin/sh
	dpkg-divert --add --local --no-rename /usr/share/man/man1/sh.1.gz
	dpkg-divert --add --local --no-rename /bin/sh
  printf "%s\n" "Shell set to bash complete" 
}

# Install/update software
update_system()
{
	printf "%s\n" "Updating system"
	apt-get -y update
	apt-get -y upgrade
	apt-get -y install python3-dev gcc g++ gfortran libraspberrypi-dev libomp-dev git-core build-essential cmake pkg-config make screen htop stress-ng zip nfs-common fail2ban ufw ntpdate bzip2 pkgconf openssl libpmix-dev libpam-dev libmariadb-dev libdbus-1-dev libmunge-dev munge
 	# Remove local SDM
  rm -rf /usr/local/sdm
 	rm -rf /usr/local/bin/sdm
  rm -rf /etc/sdm
  printf "%s\n" "System update complete"
}

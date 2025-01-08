create_slurm_user() # NOT NEEDED - moved to image build
{
	defid=990
	groupadd -g $defid slurm
	useradd -m -c "SLURM workload manager" -d /var/lib/slurm -u $defid -g slurm -s /bin/bash slurm
}

install_slurm_deps()
{
	apt-get -y install libev-libevent-dev libpam-dev libdbus-1-dev libmariadb-dev
	wget https://download.open-mpi.org/release/hwloc/v2.11/hwloc-2.11.2.tar.gz
	tar -xvf hwloc-2.11.2.tar.gz
	cd hwloc-2.11.2
	./configure --prefix=/usr/local
	make
	make all install
	ldconfig
	wget https://github.com/openpmix/openpmix/releases/download/v5.0.5/pmix-5.0.5.tar.bz2
	tar -xvf pmix-5.0.5.tar.bz2
	cd pmix-5.0.5
	./configure --prefix=/usr/local --with-hwloc=/usr/local
	make
	make all install
	ldconfig
	read -p "Slurm dependencies done"	
}

install_mariadb()
{
	#apt-get -y install mariadb-server
 	# TODO setup user/rights
  	#touch /var/log/slurmdbd.log
   	#chown slurm:slurm /var/log/slurmdbd.log
	#sudo bash -c "cat > /etc/slurm/slurmdbd.conf << EOF
# Authentication info
#AuthType=auth/munge

# slurmDBD info
#DbdAddr=localhost
#DbdHost=localhost
#SlurmUser=slurm
#DebugLevel=3
#LogFile=/var/log/slurmdbd.log
#PidFile=/run/slurmdbd.pid
#PluginDir=/usr/local/lib/slurm

# Database info
#StorageType=accounting_storage/mysql
#StorageUser=slurm
#StoragePass=dbuserpass
#StorageLoc=slurm_acct_db
#EOF"

	#chmod 600 /etc/slurm/slurmdbd.conf
	#chown slurm: /etc/slurm/slurmdbd.conf
 	sudo bash -c "cat > /etc/systemd/system/slurmdbd.service << EOF
[Unit]
Description=Slurm DBD accounting daemon
After=network.target munge.service
ConditionPathExists=/etc/slurm/slurmdbd.conf

[Service]
Type=forking
EnvironmentFile=-/etc/systemd/system/slurmdbd
ExecStart=/usr/local/sbin/slurmdbd $SLURMDBD_OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
PIDFile=/run/slurmdbd.pid

[Install]
WantedBy=multi-user.target
EOF"
	systemctl enable slurmdbd.service
 	systemctl start slurmdbd.service
 	read -p "MariaDB done"
}

install_slurm_local()
{
	#create_slurm_user
 	#install_slurm_deps
  	install_mariadb
	#wget https://download.schedmd.com/slurm/slurm-24.11.0.tar.bz2
	#tar -xvf slurm-24.11.0.tar.bz2
	#cd slurm-24.11.0
	#./configure --prefix=/usr/local --with-pmix=/usr/local --with-hwloc=/usr/local --enable-pam
	#make
	#make contrib
	#make all install
	#ldconfig
	#on headnode and compute nodes:
	#mkdir /etc/slurm
 	# TODO populate slurm.conf from online config generator
	#touch /etc/slurm/slurm.conf
	#touch /var/log/slurm.log 
	#touch /var/log/slurmd.log	
	#on headnode:
	#mkdir /var/spool/slurmctld 
	#chown slurm:slurm /var/spool/slurmctld 
	#chmod 755 /var/spool/slurmctld 
	#touch /var/log/slurmctld.log
	#touch /var/log/slurm_jobacct.log
	#on compute nodes:
	#mkdir /var/spool/slurmd 
	#chown slurm:slurm /var/spool/slurmd
	#chmod 755 /var/spool/slurmd
 	#chown slurm:slurm /var/log/slurm*.log
	#ln -s /etc/slurm/slurm.conf /usr/local/etc/slurm.conf
	
	read -p "slurm install done"
}

install_slurm_client()
{
 	apt-get -y install libev-libevent-dev libpam-dev libdbus-1-dev libmariadb-dev
  	ldconfig
 	mkdir /etc/slurm
  	
}

setup_munge_key()
{
	# Head node
	cp /etc/munge
 	# Compute node
}

install_openmpi_local()
{
	# From version 5 32 bit OS is not supported
	# Latest versions
	url32=https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.7.tar.gz
	url64=https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.6.tar.gz
	ver32="4.1.7"
	ver64="5.0.6"
	if [ $osarch = "64" ]
	then
		downlink=$url64
	 	instver=$ver64
	else
		downlink=$url32
		instver=$ver32
	fi
	cd $usrpath
	wget $downlink
	tar -xzf openmpi*.tar.gz
	cd openmpi-$instver
	./configure --prefix=/usr/local
	#cores=$(nproc)
	#make -j$cores all
	#make install	
	#ldconfig	
	#cd $usrpath
	#rm -rf openmpi*
	#mpirun --version
	read -p "OpenMPI $instver - Local install finished, press enter to return to menu" input
}

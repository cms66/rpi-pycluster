create_slurm_user()
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
	apt-get -y install mariadb-server
 	read -p "MariaDB done"
}

install_slurm_local()
{
	create_slurm_user
 	install_slurm_deps
  	install_mariadb
	wget https://download.schedmd.com/slurm/slurm-24.11.0.tar.bz2
	tar -xvf slurm-24.11.0.tar.bz2
	cd slurm-24.11.0
	./configure --prefix=/usr/local --with-pmix=/usr/local --with-hwloc=/usr/local --enable-pam
	make
	make contrib
	make all install
	ldconfig
	#on headnode and compute nodes:
	#mkdir /etc/slurm ? created during slurm build
	#touch /etc/slurm/slurm.conf ? created during slurm build
	#touch /var/log/slurm.log 
	#touch /var/log/slurmd.log
	#chown slurm:slurm /var/log/slurm*.log
	
	#on headnode:
	#mkdir /var/spool/slurmctld 
	#chown slurm:slurm /var/spool/slurmctld 
	#chmod 755 /var/spool/slurmctld 
	#touch /var/log/slurmctld.log
	#chown slurm:slurm /var/log/slurmctld.log
	#touch /var/log/slurm_jobacct.log
	#chown slurm:slurm /var/log/slurm_jobacct.log
	
	#on compute nodes:
	#mkdir /var/spool/slurmd 
	#chown slurm:slurm /var/spool/slurmd
	#chmod 755 /var/spool/slurmd
	
	#ln -s /etc/slurm/slurm.conf /usr/local/etc/slurm.conf
	
	read -p "slurm install done"
}

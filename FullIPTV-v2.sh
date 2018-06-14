#!/bin/bash
#
# FullIPTV 2.0 / Installer v2.1-rc.4
# edited by Ivan Bachvarov a.k.a SlaSerX
# Web: https://linuxhelps.net
# GitHub: https://github.com/SlaSerX/
# Email: root@linuxhelps.net
#


export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

apt-get update && apt-get upgrade -y
apt-get install postgresql -y

pg_createcluster 9.3 main --start 
/etc/init.d/postgresql start

sleep 3

echo " "
jeshile='\e[40;38;5;82m' #jeshile
jo='\e[0m' # pa ngjyra
os=$(exec uname -m|grep 64)
if [ "$os" = "" ]
then os="x86"
else os="x64"
fi
echo -e "${jeshile} ┌───────────────────────────┐ \e[0m"
echo -e "${jeshile} │  Checking System Version  │ \e[0m"
echo -e "${jeshile} └───────────────────────────┘ \e[0m"
sleep 3
echo -e "${jeshile} ┌───────────────────────────┐ \e[0m"
echo -e "${jeshile} │   Detected a $os System   │ \e[0m"
echo -e "${jeshile} └───────────────────────────┘ \e[0m"
sleep 3
echo -e "${jeshile} ┌───────────────────────────┐ \e[0m"
echo -e "${jeshile} │   Installing FullIPTV     │ \e[0m"
echo -e "${jeshile} └───────────────────────────┘ \e[0m"
echo " "

#
clear;
# clear;
# Reset
Reset='\e[0m'       # Text Reset
# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White
# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# CMS Version

CMSVER='2.0'

# Tweak nameservers
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# TWEAK SYSTEM VALUES
function tweakSystem {
	dpkg --remove-architecture i386 >> /dev/null 2>&1
	echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
	echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
	echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
	echo "fs.file-max = 32768" >> /etc/sysctl.conf
	echo "kern.maxfiles = 32768" >> /etc/sysctl.conf
	echo "kern.maxfilesperproc = 32768" >> /etc/sysctl.conf
	echo "kernel.core_uses_pid = 1" >> /etc/sysctl.conf
	echo "kernel.core_pattern = /var/crash/core-%e-%s-%u-%g-%p-%t" >> /etc/sysctl.conf
	echo "fs.suid_dumpable = 2" >> /etc/sysctl.conf
	sysctl -p >> /dev/null 2>&1
}
# SET LOCALE TO UTF-8
function setLocale {
	locale-gen en_US.UTF-8  >> /dev/null 2>&1
	export LANG="en_US.UTF-8" >> /dev/null 2>&1
}
# SET MIRRORS
function setMirrors {
	echo "deb http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME main restricted
deb-src http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME main restricted
deb http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME-updates main restricted
deb-src http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME-updates main restricted
deb http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME universe
deb-src http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME universe
deb http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME-updates universe
deb-src http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME-updates universe
deb http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME multiverse
deb-src http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME multiverse
deb http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME-updates multiverse
deb-src http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME-updates multiverse
deb http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME-backports main restricted universe multiverse
deb-src http://ubuntu.mirrors.ovh.net/ftp.ubuntu.com/ubuntu/ $DISTRIB_CODENAME-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu $DISTRIB_CODENAME-security main restricted
deb-src http://security.ubuntu.com/ubuntu $DISTRIB_CODENAME-security main restricted
deb http://security.ubuntu.com/ubuntu $DISTRIB_CODENAME-security universe
deb-src http://security.ubuntu.com/ubuntu $DISTRIB_CODENAME-security universe
deb http://security.ubuntu.com/ubuntu $DISTRIB_CODENAME-security multiverse
deb-src http://security.ubuntu.com/ubuntu $DISTRIB_CODENAME-security multiverse
	" > /etc/apt/sources.list
	if [[ "$DISTRIB_CODENAME" = "trusty" ]]; then
		echo "" >> /dev/null
	else
		echo "deb http://cdn.fulliptv.com/medibuntu/ $DISTRIB_CODENAME free non-free" >> /etc/apt/sources.list
		echo "deb-src http://cdn.fulliptv.com/medibuntu/ $DISTRIB_CODENAME free non-free" >> /etc/apt/sources.list
	fi
}

# install base packages
function installBase {
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive dpkg --configure -a >> /dev/null 2>&1
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get update -y -q >> /dev/null 2>&1
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive dpkg --configure -a >> /dev/null 2>&1
        LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install libjansson-dev -q -y --force-yes >> /dev/null 2>&1
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes -q install lsb-release apt-utils aptitude apt software-properties-common curl mtr debconf html2text wget whois whiptail vim-nox unzip tzdata sudo sysstat strace sshpass ssh-import-id tcpdump telnet screen python-software-properties python openssl ntpdate mc iptraf mailutils mlocate mtr htop gcc fuse ftp dnsutils ethtool curl dbconfig-common coreutils debianutils debconf bc bash-completion automake autoconf bwm-ng apt-utils aptitude apt git software-properties-common dos2unix dialog curl >> /dev/null 2>&1
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive dpkg --configure -a >> /dev/null 2>&1
}



function updateSSHPassword {
	NEWPASS=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1`
	NPASS=`php -r "echo base64_encode(mcrypt_encrypt(MCRYPT_RIJNDAEL_256, md5('fulliptvcrypthash'), '$NEWPASS', MCRYPT_MODE_CBC, md5(md5('fulliptvcrypthash'))));"`
	CHKUSER=`cat /etc/passwd | grep fulliptv`
	if [ -z "$CHKUSER" ]; then
		useradd -s /bin/bash -d /opt -g 0 -o -u 0 fulliptv >> /var/log/fulliptv-install.log 2>&1
	fi
	usermod --password `mkpasswd $NEWPASS` fulliptv >> /var/log/fulliptv-install.log 2>&1
}

function installDatabase {
	if [ "$ISCMS" = "1" ]; then
		if [ -z `psql -U postgres -l -A -t | grep fulliptvxx` ]; then
			psql -U postgres -c "CREATE DATABASE fulliptvxx" >> /dev/null 2>&1
			psql -U postgres fulliptvxx < /opt/fulliptv/lib/fulliptv.sql >> /dev/null 2>&1
		else
			echo "${BCyan}Database found, skipping installing initial database...${Reset}";
		fi
	fi
}
function addServer {
	SERVERPORT=`cat /etc/ssh/sshd_config | grep "Port " | cut -d" " -f2`
	TOKEN=`php -r "echo md5(\"${SERVERIP}\");"`
	RES=`curl -s "http://$CMSURL:$CMSPORT/cron?addServer=true&server_name=$SERVERNAME&server_ip=$SERVERIP&server_private_ip=$SERVERINTIP&server_port=$SERVERPORT&server_auth=$NEWPASS&token=$TOKEN"`
	if [ "$RES" = "OK" ]; then
		echo -e "${BGreen}Server added to the database !${Reset}";
	fi
	if [ "$RES" = "UPDATED" ]; then
		echo -e "${BGreen}Server updated into database !${Reset}";
	fi
}
function addServerToDatabase {
	CHK=`PGPASSWORD="Pass22pp2019ssh808" psql -U postgres -h $CMSURL fulliptvxx -A -t -c "SELECT id FROM servers WHERE server_host = '$SERVERNAME'"` >> /dev/null 2>&1
	if [ -z "$CHK" ]; then
		SERVERPORT=`cat /etc/ssh/sshd_config | grep "Port " | cut -d" " -f2`
		PGPASSWORD="Pass22pp2019ssh808" psql -U postgres -h $CMSURL fulliptvxx -A -t -c "INSERT INTO servers ( server_name, server_host, server_ip, server_private_ip, server_port, server_upload, server_download, server_max_clients, server_max_channels, active, status, server_auth ) VALUES ( '$SERVERNAME', '$SERVERNAME', '$SERVERIP', '$SERVERINTIP', '$SERVERPORT', '1000', '1000', '1000', '1000', 't', 't', '${NPASS}' )" >> /dev/null 2>&1
		echo -e "${BGreen}Server added to the CMS !${Reset}";
	else
		echo -e "${BGreen}This server is already added to the CMS !${Reset}";
	fi
}

function updateServerDatabasePass {
	PGPASSWORD="Pass22pp2019ssh808" psql -U postgres -h $CMSURL fulliptvxx -c "UPDATE servers SET server_auth = '$NPASS' WHERE server_host = '$SERVERNAME'" >> /var/log/fulliptv-install.log 2>&1
}

function writeConfig {
	mkdir -p /opt/fulliptv/etc/ >> /dev/null 2>&1
	echo "CMSURL=$CMSURL" > /opt/fulliptv/etc/fulliptv.conf
	echo "CMSPORT=$CMSPORT" >> /opt/fulliptv/etc/fulliptv.conf
	echo "SERVERNAME=$SERVERNAME" >> /opt/fulliptv/etc/fulliptv.conf	
	echo "SERVERIP=$SERVERIP" >> /opt/fulliptv/etc/fulliptv.conf
	echo "SERVERINTIP=$SERVERINTIP" >> /opt/fulliptv/etc/fulliptv.conf
	echo "ISCMS=$ISCMS" >> /opt/fulliptv/etc/fulliptv.conf
	echo "ISSTREAMER=$ISSTREAMER" >> /opt/fulliptv/etc/fulliptv.conf
}

function upgradeFiles {
	if [ "$ISCMS" = "1" ]; then
		wget -O /tmp/fulliptv.tgz http://lab.itbox.bg/software/panel/fulliptv-cms.tgz >> /dev/null 2>&1
		tar xzvf /tmp/fulliptv.tgz -C /opt >> /dev/null 2>&1
		rm -rf /tmp/fulliptv.tgz >> /dev/null 2>&1
	fi
	if [ "$ISSTREAMER" = "1" ]; then
		wget -O /tmp/fulliptv.tgz http://lab.itbox.bg/software/panel/fulliptv-streamer.tgz >> /dev/null 2>&1
		tar xzvf /tmp/fulliptv.tgz -C /opt >> /dev/null 2>&1
		rm -rf /tmp/fulliptv.tgz >> /dev/null 2>&1
	fi
}

function installCMSPackages {
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive dpkg --configure -a >> /dev/null 2>&1
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install php5-fpm php5-mcrypt php5-pgsql php5-cli php5-curl php5-gd php-pear libssh2-php php5-json libxslt1.1 daemontools postgresql-client -q -y --force-yes >> /dev/null 2>&1
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install libva1 libxfixes3 libxext6 libasound2 libsdl1.2debian libtheora0 libmp3lame0 libass4 libvdpau1 daemontools postgresql-client apache2 php5 libapache2-mod-php5 -q -y --force-yes >> /dev/null 2>&1
	if [ "$DISTRIB_CODENAME" != "trusty" ]; then
		LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install postgresql-9.3 -y --force-yes >> /dev/null 2>&1
		echo -e "local all postgres trust\n" > /etc/postgresql/9.3/main/pg_hba.conf
		echo -e "local all all trust\n" >> /etc/postgresql/9.3/main/pg_hba.conf
		echo -e "host all all 127.0.0.1/32 trust\n" >> /etc/postgresql/9.3/main/pg_hba.conf
		echo -e "host all all ::1/128 trust\n" >> /etc/postgresql/9.3/main/pg_hba.conf
		# echo -e "host all all 0.0.0.0/0 md5\n" >> /etc/postgresql/9.3/main/pg_hba.conf
		echo -e "listen_addresses = '*'\n" >> /etc/postgresql/9.3/main/postgresql.conf
	else
		LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install postgresql-9.3 -y --force-yes >> /dev/null 2>&1
		echo -e "local all postgres trust\n" > /etc/postgresql/9.3/main/pg_hba.conf
		echo -e "local all all trust\n" >> /etc/postgresql/9.3/main/pg_hba.conf
		echo -e "host all all 127.0.0.1/32 trust\n" >> /etc/postgresql/9.3/main/pg_hba.conf
		echo -e "host all all ::1/128 trust\n" >> /etc/postgresql/9.3/main/pg_hba.conf
		# echo -e "host all all 0.0.0.0/0 md5\n" >> /etc/postgresql/9.3/main/pg_hba.conf
		echo -e "listen_addresses = '*'\n" >> /etc/postgresql/9.3/main/postgresql.conf
	fi
	/etc/init.d/postgresql restart >> /var/log/fulliptv-install.log 2>&1
	psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'Pass22pp2019ssh808'" >> /var/log/fulliptv-install.log 2>&1
}

function installStreamerPackages {
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive dpkg --configure -a >> /dev/null 2>&1
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install daemontools postgresql-client x264 -q -y --force-yes >> /dev/null 2>&1
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get purge -y --force-yes -qq vlc-data vlc-nox vlc >> /dev/null 2>&1
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get autoremove -y --force-yes -qq >> /dev/null 2>&1
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes -qq ubuntu-restricted-extras >> /dev/null 2>&1
	LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get update >> /dev/null 2>&1
	if [ "$DISTRIB_CODENAME" = "saucy" ]; then
		LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes -qq vlc-nox vlc ffmpeg non-free-codecs x264 php5 php5-mcrypt >> /dev/null 2>&1
	elif [ "$DISTRIB_CODENAME" = "trusty" ]; then
		LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes -qq vlc-nox vlc x264 php5 php5-mcrypt >> /dev/null 2>&1
	else 
		LANG=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes -qq vlc-nox vlc ffmpeg non-free-codecs x264 php5 php5-mcrypt >> /dev/null 2>&1
	fi

	setupMcrypt;
}

function setupCMS {
	CHKZEND=`cat /etc/php5/apache2/php.ini | grep zend_exten`
        if [ -z "$CHKZEND" ]; then
                echo "zend_extension=/opt/fulliptv/lib/ioncube/ioncube_loader_lin_5.5.so" >> /etc/php5/apache2/php.ini
        fi
        CHKZEND=`cat /etc/php5/cli/php.ini | grep zend_exten`
        if [ -z "$CHKZEND" ]; then
                echo "zend_extension=/opt/fulliptv/lib/ioncube/ioncube_loader_lin_5.5.so" >> /etc/php5/cli/php.ini
        fi
        apt-get install -y --force-yes apache2 -q >> /dev/null 2>&1
        /etc/init.d/nginx stop >> /dev/null 2>&1
        cp -R /etc/php5/conf.d/* /etc/php5/apache2/conf.d/ >> /dev/null 2>&1
        cp -R /etc/php5/conf.d/* /etc/php5/cli/conf.d/ >> /dev/null 2>&1
        php5enmod ssh2 >> /dev/null 2>&1
        php5enmod mcrypt >> /dev/null 2>&1
        a2enmod rewrite >> /dev/null 2>&1

        killall -9 nginx >> /dev/null 2>&1
        killall -9 php5-fpm >> /dev/null 2>&1
        killall -9 php-fpm >> /dev/null 2>&1
	echo "Listen $CMSPORT" > /etc/apache2/ports.conf
        echo "<VirtualHost *:$CMSPORT>
        ServerAdmin info@fulliptv.com
        ServerName ${CMSURL}
        DocumentRoot /opt/fulliptv/portal
        <Directory />
                Options FollowSymLinks
                AllowOverride All
                Require all granted
        </Directory>
        <Directory /opt/fulliptv/portal>
                Options FollowSymLinks
                AllowOverride All
                Require all granted
        </Directory>
        ErrorLog \${APACHE_LOG_DIR}/${CMSURL}-error.log
        LogLevel warn
        CustomLog \${APACHE_LOG_DIR}/${CMSURL}-access.log combined
</VirtualHost>
" > /etc/apache2/sites-enabled/000-default.conf
        /etc/init.d/apache2 restart >> /dev/null 2>&1
        CHKRC=`cat /etc/crontab | grep fulliptv`
        if [ -z "$CHKRC" ]; then
                echo "*/5 * * * * root wget -O /dev/null \"http://${CMSURL}/cron.php\" >> /dev/null 2>&1" >> /etc/crontab
        fi
        psql -U postgres fulliptvxx -c "UPDATE settings SET config_value = '$CMSVER' WHERE config_name = 'current_version' OR config_name = 'new_version'" >> /dev/null 2>&1
}	
function setupMcrypt {
	php5enmod mcrypt >> /dev/null 2>&1
        cp -R /etc/php5/conf.d/* /etc/php5/apache2/conf.d/ >> /dev/null 2>&1
        cp -R /etc/php5/conf.d/* /etc/php5/cli/conf.d/ >> /dev/null 2>&1
}


function setupStreamer {
        cp -R /etc/php5/conf.d/* /etc/php5/apache2/conf.d/ >> /dev/null 2>&1
        cp -R /etc/php5/conf.d/* /etc/php5/cli/conf.d/ >> /dev/null 2>&1
        php5enmod mcrypt >> /dev/null 2>&1
	( killall -9 hitrow vlc supervise ; supervise /opt/fulliptv/bin & ) >> /dev/null 2>&1
	CHKRC=`cat /etc/rc.local | grep fulliptv`
	if [ -z "$CHKRC" ]; then
		echo "( killall -9 hitrow vlc supervise ; supervise /opt/fulliptv/bin & ) >> /dev/null 2>&1" > /etc/rc.local
	fi
}

function cleanUp {
	# Remove any temp data or package data.
	if [ "$ISSTREAMER" = "1" ]; then
		/etc/init.d/apache2 stop >> /dev/null 2>&1
		( killall -9 hitrow vlc supervise ; supervise /opt/fulliptv/bin & ) >> /dev/null 2>&1
	fi
	if [ "$ISCMS" = "1" ]; then
		/etc/init.d/apache2 start >> /dev/null 2>&1
	fi
	apt-get purge -y --force-yes fulliptv nginx -q >> /dev/null 2>&1
	
        /etc/init.d/nginx stop >> /dev/null 2>&1
	killall -9 php5-fpm >> /dev/null 2>&1
	killall -9 php-fpm >> /dev/null 2>&1
	killall -9 nginx >> /dev/null 2>&1
	rm -rf /opt/fulliptv/lib/fulliptv.sql >> /dev/null 2>&1
	rm -rf /opt/fulliptv/lib/nginx* >> /dev/null 2>&1
	rm -rf /tmp/fulliptv* >> /dev/null 2>&1
	mkdir /opt/fulliptv/vod >> /dev/null 2>&1
	chown -R www-data:www-data /opt/fulliptv >> /dev/null 2>&1
	chmod -R 777 /opt/fulliptv/vod >> /dev/null 2>&1
	wget -O /dev/null "http://cdn.fulliptv.com/install.php?cmsurl=$CMSURL&servername=$SERVERNAME&serverip=$SERVERIP&serverintip=$SERVERINTIP&iscms=$ISCMS&isstreamer=$ISSTREAMER" > /dev/null 2>&1
	
}


### STARTING PROPER SCRIPT ### 
tweakSystem;
setLocale;
#setMirrors;
installBase;

# Gathering latest version of software
CMSVER=`curl -s "http://cdn.fulliptv.com/VERSION" | xargs`
HITVER=`curl -s "http://cdn.fulliptv.com/HITROWVERSION" | xargs`

# UPGARDE IF EXISTING INSTALLATION
if [ -f /opt/fulliptv/etc/fulliptv.conf ]; then
	. /opt/fulliptv/etc/fulliptv.conf >> /dev/null 2>&1
	if [ -z "$CMSPORT" ]; then
		CMSPORT="80"
	fi
	CURVER=`cat /opt/fulliptv/etc/VERSION`
	# CHECK IF UPDATE NEEDED
	if [ "$CMSVER" = "$CURVER" ]; then
		if [ "$1" != "force" ]; then
			echo -e "${BCyan}You already have the latest version ${BYellow}v$CMSVER${BCyan}, no update to make!${Reset}";
			exit 0;
		else 
			echo -e "${BCyan}Forcing update!${Reset}";
		fi
	fi
	
	setupMcrypt;
	upgradeFiles;
	updateSSHPassword;
	if [ "$ISCMS" = "1" ]; then
		# UPDATE CMS
		echo -e "${BGreen}Updating CMS${Reset}";
        	psql -U postgres fulliptvxx -c "UPDATE settings SET config_value = '$CMSVER' WHERE config_name = 'current_version' OR config_name = 'new_version'" >> /dev/null 2>&1
	fi
	if [ "$ISSTREAMER" = "1" ]; then
		# UPDATE STREAMER
		echo -e "${BGreen}Updating streamer${Reset}";
		addServer;
		# updateServerDatabasePass;
	fi
	cleanUp;
	echo -e "${BGreen}Updated to version ${BYellow}v$CMSVER${BGreen} !${Reset}";
# NEW INSTALL
else
	echo -ne "${BWhite}What to install ? ( 1|CMS , 2|STREAMER , 3|ALL-IN-ONE ) : ${Reset}";
	read SERVERTYPE
	if [ "$SERVERTYPE" = "1" ]; then
		ISCMS=1
		ISSTREAMER=0
	fi
	if [ "$SERVERTYPE" = "2" ]; then
		ISCMS=0
		ISSTREAMER=1
	fi
	if [ "$SERVERTYPE" = "3" ]; then
		ISCMS=1
		ISSTREAMER=1
	fi
	if [[ "$SERVERTYPE" != "1" && "$SERVERTYPE" != "2" && "$SERVERTYPE" != "3" ]]; then
		echo -e "${Red}You didn't selected anything! Aborting.${Reset}";
		exit;
	fi
	echo -ne "${BWhite}CMS URL without http:// ( subdomain.domain.com ) : ${Reset}";
	read CMSURL
	if [ -z "$CMSURL" ]; then
		echo -e "${BRed}You need to provide CMS URL !${Reset}";
		exit 1;
	fi
	echo -ne "${BWhite}CMS PORT, numeric only ( 8080 ) : ${Reset}";
	read CMSPORT
	if [ -z "$CMSPORT" ]; then
		CMSPORT="80"
	fi
	if [[ "$SERVERTYPE" = "3" && "$CMSPORT" = "80" ]]; then
		echo -e "${Red}You MUST use different port for cms if you want to install all in one! Aborting.${Reset}";
		exit;
	fi
	echo -ne "${BWhite}SERVER NAME ( ex. s01.domain.com ) : ${Reset}";
	read SERVERNAME
	if [ -z "$SERVERNAME" ]; then
		echo -e "${BRed}You need to provide SERVER NAME !${Reset}";
		exit 1;
	fi
	echo -ne "${BWhite}EXTERNAL IP ADDRESS : ${Reset}";
	read SERVERIP
	if [ -z "$SERVERIP" ]; then
		echo -e "${BRed}You need to provide EXTERNAL IP !${Reset}";
		exit 1;
	fi
	echo -ne "${BWhite}PRIVATE IP ADDRESS, if you don't have, same as above : ${Reset}";
	read SERVERINTIP
	if [ -z "$SERVERINTIP" ]; then
		echo -e "${BRed}You need to provide PRIVATE IP !${Reset}";
		exit 1;
	fi
	
	writeConfig;
	upgradeFiles;
	### FROM HERE WE INSTALL EVERYTHING ###
	if [ "$ISCMS" = "1" ]; then
		# Install packages
		installCMSPackages;
		# Install INITIAL DATABASE
		installDatabase;
		# Setup configs
		setupCMS;
	fi
		
	if [ "$ISSTREAMER" = "1" ]; then
		# Install packages
		installStreamerPackages;
		# Setup streamer
		setupStreamer;
		# Make new ssh password
		updateSSHPassword;
		# Add the streamer to database
		addServer;
		# addServerToDatabase;
	fi
	# Removing temp files, restarting services
	cleanUp;
	echo -e "${BGreen}Installed version ${BYellow}v$CMSVER${BGreen} !${Reset}";	
fi
echo " "
echo "####################################################################################"
echo " "
echo "Remove Installation files"
echo " "
rm -rf /root/FullIPTV/FullIPTV-v2.sh
echo " "
echo "####################################################################################"
echo " "
echo "FullIPTV 2.0 edited by Ivan Bachvarov a.k.a SlaSerX"
echo " "
echo "Installation Complete..."
echo " "
echo "Server must be Rebooted !!!"
      read -p "Reboot (y/n)?" CONT
      if [ "$CONT" == "y" ] || [ "$CONT" == "Y" ]; then
      reboot
      fi


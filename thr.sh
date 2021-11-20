#!/usr/bin/bash

# OPEN SOURCE PROJECT TERMUX-HACKING-REPO
# CODE BY CRAGLITCH 
function id01() {
	# Metasploit Framework by gushmazuko modified by Craglitch Ruby3
	# Remove not working repositories

	rm $PREFIX/etc/apt/sources.list.d/*
	# Install gnupg required to sign repository
	pkg install -y gnupg

	# Sign gushmazuko repository
	curl -fsSL https://raw.githubusercontent.com/gushmazuko/metasploit_in_termux/master/gushmazuko-gpg.pubkey | gpg --dearmor | tee $PREFIX/etc/apt/trusted.gpg.d/gushmazuko-repo.gpg

	# Add gushmazuko repository to install ruby 2.7.2 version
	echo 'deb https://github.com/gushmazuko/metasploit_in_termux/raw/master gushmazuko main'  | tee $PREFIX/etc/apt/sources.list.d/gushmazuko.list
	# Set low priority for all gushmazuko repository (for security purposes)
	# Set highest priority for ruby package from gushmazuko repository
	echo '## Set low priority for all gushmazuko repository (for security purposes)
	Package: *
	Pin: release gushmazuko
	Pin-Priority: 100
	## Set highest priority for ruby package from gushmazuko repository
	Package: ruby
	Pin: release gushmazuko
	Pin-Priority: 1001' | tee $PREFIX/etc/apt/preferences.d/preferences
	# Purge installed ruby
	apt purge ruby -y
	rm -fr $PREFIX/lib/ruby/gems
	pkg upgrade -y -o Dpkg::Options::="--force-confnew"
	pkg install -y python autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config git ruby -o Dpkg::Options::="--force-confnew"
	python3 -m pip install --upgrade pip
	python3 -m pip install requests
	source <(curl -sL https://github.com/termux/termux-packages/files/2912002/fix-ruby-bigdecimal.sh.txt)
	rm -rf $HOME/metasploit-framework
	cd $PREFIX/share
	git clone https://github.com/rapid7/metasploit-framework.git --depth=1
	cd $PREFIX/share/metasploit-framework
	sed '/rbnacl/d' -i Gemfile.lock
	sed '/rbnacl/d' -i metasploit-framework.gemspec
	gem install bundler
	sed 's|nokogiri (1.*)|nokogiri (1.8.0)|g' -i Gemfile.lock
	gem install nokogiri -v 1.8.0 -- --use-system-libraries
	gem install actionpack
	bundle update activesupport
	bundle update --bundler
	bundle install -j$(nproc --all)
	$PREFIX/bin/find -type f -executable -exec termux-fix-shebang \{\} \;
	rm ./modules/auxiliary/gather/http_pdf_authors.rb
	if [ -e $PREFIX/bin/msfconsole ];then
	rm $PREFIX/bin/msfconsole
	fi
	if [ -e $PREFIX/bin/msfvenom ];then
		rm $PREFIX/bin/msfvenom
	fi
	ln -s $PREFIX/share/metasploit-framework/msfconsole /data/data/com.termux/files/usr/bin/
	ln -s $PREFIX/share/metasploit-framework/msfvenom /data/data/com.termux/files/usr/bin/
	termux-elf-cleaner /data/data/com.termux/files/usr/lib/ruby/gems/*/gems/pg-*/lib/pg_ext.so
	rm $PREFIX/etc/apt/source.list.d/gushmazuko.list
	clear
	echo "[31mDo not upgrade ruby or msf stop working !!!"
	echo "[32mINSTALLATION TO BINARY IS COMPLETE LAUNCH : msfconsole"
	cd
}

# INSTALLATION FOR ID 02 PACKAGES
function id02() {
	pkg update && pkg upgrade -y
	pkg install -y clang make openssl openssl-tool wget openssh coreutils gtk2 gtk3 git
	cd $PREFIX/share
	git clone https://github.com/vanhauser-thc/thc-hydra
	cd $PREFIX/share/thc-hydra
	./configure --prefix=$PREFIX
	make
	make install
	ln -s $PREFIX/share/thc-hydra/hydra $PREFIX/bin
	clear
	echo "[32mINSTALLATION TO BINARY IS COMPLETE LAUNCH : hydra"
	cd

}

function installing() {
	# INSTALLATION ID PACKAGES 
	if [ $id == '01' ]; then
		id01

	elif [ $id == '02' ]; then
		id02
	elif [ $id == '03' ]; then
		apt update && apt upgrade -y
		apt install nmap
		echo "Installation Done Launch : nmap -h"
	elif [ $id == '04' ]; then
		apt update && apt upgrade -y
		apt install python -y
		pip install sqlmap
		echo "Installation Done Launch : sqlmap"
	else
		return 0
	fi
}

#--------------------------------------------------------------

clear
echo "
[31m
   TermuxPenatrationTesting - Project[33m

+----+----------------------------+---------+
| ID |          PACKAGES          | STATUS  |
+----+----------------------------+---------+
| 01 | Metasploit Framework       | Avaible |
| 02 | Thc-Hydra                  | Avaible |
| 03 | Nmap                       | Avaible |
| 04 | SQLmap                     | Avaible |
| 05 | Social Enginnering toolkit |  Soon   |
+----+----------------------------+---------+
Ctrl C to exit // Code by Craglitch [34m
"
# input id number to install id package
read -p 'PACKAGES ID : ' id
# calling function id package installer
installing






























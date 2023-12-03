curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
chmod 755 msfinstall
# sudo mv /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/ # fix warning
sudo ./msfinstall
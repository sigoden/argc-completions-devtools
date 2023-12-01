## Argc-completion Devtools

## prepare

```sh
apt install git build-essential libb2-dev
cargo install argc
argc update-commands -k apt
argc update-commands -k brew
argc update-commands -k brew-tab
```

## bashrc

```sh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
. $HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh
export PATH="$PATH:$(go env GOPATH)/bin:$HOMEBREW_PREFIX/lib/ruby/gems/3.2.0/bin:$HOME/.config/composer/vendor/bin"
eval "$(pyenv init -)"
```

## manual

### brew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### rustup & cargo

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### python

```
pyenv install 3.11.6
pyenv global 3.11.6 
```

### docker

```sh
/bin/bash -c "$(curl -fsSL https://get.docker.com/)"
```

### nix
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### vscode

```sh
curl -L -o /tmp/vscode.deb https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64
sudo dpkg -i /tmp/vscode.deb
```

### metasploit-framework

```sh
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
sudo mv /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/ # fix warning
```

### mongodb

```sh
sudo apt-get install gnupg curl
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-update
sudo apt install mongodb-database-tools mongodb-mongosh
```

### gcloud

see https://cloud.google.com/sdk/docs/install#deb

### ngork

see https://ngrok.com/download

### keybase

```sh
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt install ./keybase_amd64.deb
sudo apt install -f
```

### kubeadm

```sh
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
# sudo apt-mark hold kubelet kubeadm kubectl
```

## wezterm

see https://wezfurlong.org/wezterm/install/linux.html


## laravel

```sh
composer global require laravel/installer
```
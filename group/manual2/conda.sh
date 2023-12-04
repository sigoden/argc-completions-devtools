wget -O miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./miniconda.sh -b -u -p ~/.miniconda3
# echo 'export PATH="$HOME/.miniconda3/bin:$PATH"' >> ~/.bashrc
ln -s ~/.miniconda3/bin/conda ~/.local/bin/conda
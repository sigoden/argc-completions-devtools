wget  -O dotnet-install.sh https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --version latest
echo 'export PATH="$HOME/.dotnet:$PATH"' >> ~/.bashrc
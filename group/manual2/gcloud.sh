# NEED-MANUALLY-SYNC
# https://cloud.google.com/sdk/docs/install#deb
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-455.0.0-linux-x86_64.tar.gz
sudo tar -C /opt/ -xf google-cloud-cli-455.0.0-linux-x86_64.tar.gz
echo 'export PATH="/opt/google-cloud-sdk/bin:$PATH"' >> ~/.bashrc
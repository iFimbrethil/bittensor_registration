#!/bin/bash

source .venv/bin/activate

# Check if PM2 is already installed
if ! command -v pm2 &> /dev/null; then
    echo "PM2 is not installed. Proceeding with installation..."

    # Update package lists
    sudo apt-get update

    # Install aptitude package manager
    sudo apt install aptitude -y

    # Install libnode-dev
    sudo aptitude install libnode-dev -y

    # Install node-gyp
    sudo aptitude install node-gyp -y

    # Install npm
    sudo aptitude install npm -y

    # Install pm2 globally using npm
    sudo npm install pm2 -g

    echo "PM2 has been successfully installed."
else
    echo "PM2 is already installed. Skipping installation."
fi

# Write register.py file
echo "Writing register.py file..."
echo 'import os' > register.py
echo 'import bittensor' >> register.py
echo 'os.remove(".bittensor/wallets/default/hotkeys/default")' >> register.py
echo 'os.system("btcli new_hotkey --wallet.name default --hotkey.name default --no_prompt")' >> register.py
echo 'os.system("btcli register --no_prompt --wallet.name default --wallet.hotkey default --cuda.use_cuda --cuda.dev 0 1 2 3 4 5 6 7 --netuid 1")' >> register.py
echo "register.py file has been created."

# Write ecosystem.config.js file
echo "Writing ecosystem.config.js file..."
echo "module.exports = {" > ecosystem.config.js
echo "  apps: [" >> ecosystem.config.js
echo "    {" >> ecosystem.config.js
echo "      name: 'register'," >> ecosystem.config.js
echo "      script: 'python3'," >> ecosystem.config.js
echo "      args: 'register.py --no_prompt --wallet.name default --wallet.hotkey default --cuda.use_cuda --cuda.dev_id 0 1 2 3 4 5 6 7'" >> ecosystem.config.js
echo "    }," >> ecosystem.config.js
echo "  ]," >> ecosystem.config.js
echo "};" >> ecosystem.config.js
echo "ecosystem.config.js file has been created."

# Execute register.py
echo "Starting registration in PM2..."
pm2 start ecosystem.config.js
echo "registration started!"

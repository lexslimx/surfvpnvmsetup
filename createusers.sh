# Create directories
mkdir /tmp/surfvpn
mkdir /tmp/surfvpn/app

# remove git directory
rm -rf /tmp/git/

- Download the .net app from github
yes | git clone git@github.com:lexslimx/surfvpnprovisioning.git  /tmp/git/

cd /tmp/git/VpnHelper/VpnHelper
git pull

# Build and publish the app
dotnet restore
dotnet publish -c Release -r linux-x64 -o /tmp/surfvpn/app

# Download usernames
chmod 777 /tmp/surfvpn/app/VpnHelper
sudo /tmp/surfvpn/app/VpnHelper GetUsers

CLIENTS_FILE="/tmp/surfvpn/surfvpnusernames.txt"

# Download the script
echo "Setting OpenVPN path..."

curl -o /tmp/surfvpn/openvpn-install.sh https://raw.githubusercontent.com/lexslimx/openvpn-install/master/openvpn-install.sh
SCRIPT_PATH="/tmp/surfvpn/openvpn-install.sh"


# Loop through each line in the clients file
echo "Creating users..."
while IFS= read -r CLIENT; do
  echo "Creating user: $CLIENT"
  # Export environment variables
  export MENU_OPTION="1"
  export CLIENT="$CLIENT"
  export PASS="1"

  # Execute the command/script
  chmod 777 /tmp/surfvpn/openvpn-install.sh
  /tmp/surfvpn/openvpn-install.sh

  # Optionally, you might want to unset variables if needed
  unset CLIENT
echo "Done creating users..."
done < "$CLIENTS_FILE"

# Dotnet Upload Users
sudo /tmp/surfvpn/app/VpnHelper UploadFiles
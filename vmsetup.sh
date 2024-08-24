# Run on start up of a virtual machine via a custom script extension.

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

# copy the user creation script to /tmp/surfvpn/ from the app directory
cp /tmp/surfvpn/app/createusers.sh /tmp/surfvpn/createusers.sh

#!/bin/bash

# ==============================
# SRCDS Server Installer
# Written for Ubuntu Sysems
#
# ./srcds_install.sh -b /home/ -u username gameid
# ==============================

# Allows enough time for PufferPanel to get the Feed
sleep 5

username=root
base="/home/"

while getopts ":b:u:" opt; do
    case "$opt" in
    b)
        base=$OPTARG
        ;;
    u)
        username=$OPTARG
        ;;
    esac
done

if [ "${username}" == "root" ]; then

    echo "WARNING: Invalid Username Supplied."
    exit 1

fi;

shift $((OPTIND-1))

if [ ! -d "${base}${username}/public" ]; then
    echo "The home directory for the user (${base}${username}/public) does not exist on the system."
    exit 1
fi;

cd ${base}${username}/public

mkdir steamcmd && cd steamcmd

curl -O http://media.steampowered.com/installer/steamcmd_linux.tar.gz
tar -xzvf steamcmd_linux.tar.gz && rm -rf steamcmd_linux.tar.gz

cd ../

chown -R ${username}:scalesuser *

# SteamCMD is strange about the user who installs it and where it places some files.
su - ${username} -c "cd public/steamcmd && ./steamcmd.sh +login anonymous +force_install_dir ${base}${username}/public +app_update $1 +quit 2>&1"

# Save SRCDS Run File for MD5 Checking
cd ${base}${username}
cp public/srcds_run .

chown -R ${username}:scalesuser *

exit 0
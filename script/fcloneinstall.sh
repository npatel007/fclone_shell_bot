#!/bin/bash
rm -rf fclone.sh
wget https://raw.githubusercontent.com/cgkings/fclone_shell_bot/master/script/fclone.sh
echo  " [Fclone one-click dump script for own use] script configuration "
read -p " Enter the name of the configuration fclone: " fcloneid
sed -i "s/goog/$fcloneid/g" fclone.sh
read -p " Please enter 0# turntable ID (default): " tdid0
sed -i "s/myid0/$tdid0/g" fclone.sh
read -p " Please enter 1#ADV disk ID: " tdid1
sed -i "s/myid1/$tdid1/g" fclone.sh
read -p " Please enter 2#MDV disk ID: " tdid2
sed -i "s/myid2/$tdid2/g" fclone.sh
read -p " Please enter 3#BOOK disk ID: " tdid3
sed -i "s/myid3/$tdid3/g" fclone.sh
echo  " If you need to increase or decrease the target address, you can modify fcloneinstall.sh and fclone.sh "
mkdir -p ~/gclone_log/
chmod +x fclone.sh
echo  " Please enter ./fclone.sh to use the script "

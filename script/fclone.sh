#!/bin/bash
# Author: cgking
# Created Time : 2020.7.4
# File Name: fclone.sh
# Description:
read -p "Please enter a sharing link ==>" link
# Check the standardization of the shared link received and convert the shared file ID
if [ -z "$link" ] ; then
    echo "The input is not allowed to be empty" && exit
else
link=${link#*id=};
link=${link#*folders/};
link=${link#*d/};
link=${link%?usp*}
id=$link
rootName=$(fclone lsf goog:{$id} --dump bodies -vv 2>&1 | grep '"'$id'","name"' | cut -d '"' -f 8)
echo -e "▣▣▣▣▣▣▣▣Task Information▣▣▣▣▣▣▣▣\n" 
    echo -e "┋Resource name┋:$rootName \n"
    echo -e "┋Resource address┋:$link \n"
be
echo -e "fclone self-use version [v1.0 by \e[1;34m cgkings \e[0m]
[0]. Transferring ID of transfer disk
[1]. ADV disk ID transfer
[2]. MDV disk ID transfer
[3]. BOOK disk ID transfer
[4]. Custom ID transfer"
read -t 10 -n1 -p "Please enter the number [0-4]: (10s select 0 by default)" num
num = $ {num: -0}
case "$num" in
0)
    echo -e " \n "
    echo -e "★★★ 0#中转盘★★★"
    myid = myid0
    ;;
1)
    echo -e " \n "
    echo -e "★★★ 1#ADV盘★★★"
    myid = myid1
    ;;
2)
    echo -e " \n "
    echo -e "★★★ 2#MDV盘★★★"
    myid = myid2
    ;;
3)
    echo -e " \n "
    echo -e "★★★ 3#BOOK盘 ★★★"
    myid = myid3
    ;;
4)
    echo -e " \n "
    echo -e "★★★ 4# custom disk ★★★"
    echo -e "\n"
    read -p "Please enter a custom dump ID:" myid5
    myid = $ myid5
    ;;
*)
    echo -e " \n "
    echo -e "Please enter the correct number"
    ;;
esac
echo -e " \n "
echo -e "▣▣▣▣▣▣Executing dump▣▣▣▣▣▣"
fclone copy goog:{$link} goog:{$myid}/"$rootName" --drive-server-side-across-configs -vP --checkers=128 --transfers=256 --drive-pacer-min-sleep=1ms --drive-pacer-burst=5000 --check-first --stats-one-line --stats=1s --min-size 10M --log-file=/root/gclone_log/"$rootName"'_copy1.txt'
echo "|▉▉▉▉▉▉▉▉▉▉▉▉|100% copy finished"
echo -e "▣▣▣▣▣▣ is performing synchronization▣▣▣▣▣▣"
fclone sync goog:{$link} goog:{$myid}/"$rootName" --drive-server-side-across-configs -vP --checkers=128 --transfers=256 --drive-pacer-min-sleep=1ms --drive-pacer-burst=5000 --check-first --drive-use-trash=false --stats-one-line --stats=1s --min-size 10M --log-file=/root/gclone_log/"$rootName"'_copy2.txt'
echo "|▉▉▉▉▉▉▉▉▉▉▉▉|100% synchronization complete"
echo -e "▣▣▣▣▣▣ is performing a duplicate check▣▣▣▣▣▣"
fclone dedupe newest goog:{$myid}/"$rootName" --fast-list --drive-use-trash=false --no-traverse --size-only -v --log-file=/root/gclone_log/"$rootName"'_dedupe.txt'
echo "|▉▉▉▉▉▉▉▉▉▉▉▉|100% check completed"
echo -e "▣▣▣▣▣▣ is performing comparison▣▣▣▣▣▣"
fclone check goog:{$link} goog:{$myid}/"$rootName" --fast-list --size-only --one-way --no-traverse --min-size 10M --checkers=64 --drive-pacer-min-sleep=1ms
echo "|▉▉▉▉▉▉▉▉▉▉▉▉|100% comparison is complete"
echo
echo -e "Please note that emptying the recycle bin, the group account must have administrator rights to the team disk, do not select the default N for 10s"
echo -e "\n"
read -t 10 -n1 -p "Do you want to empty the recycle bin [Y/N]?" answer
answer=${answer:-N}
case "$answer" in
And | and)
    echo -e " \n "
    echo -e "▣▣▣▣▣▣▣▣Empty recycle bin▣▣▣▣▣▣▣▣\n"
    fclone delete goog:{$myid} --fast-list --drive-trashed-only --drive-use-trash=false --drive-server-side-across-configs --checkers=64 --transfers=128 --drive-pacer-min-sleep=1ms --drive-pacer-burst=5000 --check-first --log-level INFO --log-file=/root/gclone_log/"$rootName"'_trash.txt'
    fclone rmdirs goog:{$myid} --fast-list --drive-trashed-only --drive-use-trash=false --drive-server-side-across-configs --checkers=64 --transfers=128 --drive-pacer-min-sleep=1ms --drive-pacer-burst=5000 --check-first --log-level INFO --log-file=/root/gclone_log/"$rootName"'_rmdirs.txt'
    echo -e "|▉▉▉▉▉▉▉▉▉▉▉▉|100% recycle bin is emptied
    echo -e "Log file storage path /root/gclone_log/"$rootName"_(copy1/copy2/dedupe/trash/rmdirs).txt"
    ;;
N | n)
    echo -e " \n "
    echo -e "default: do not empty the recycle bin"
    echo -e "Log file storage path /root/gclone_log/"$rootName"_(copy1/copy2/dedupe).txt"
    ;;
*)
    echo -e " \n "
    echo -e "Please enter the correct number"
    ;;
esac
./fclone.sh

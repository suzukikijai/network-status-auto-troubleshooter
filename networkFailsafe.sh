#!/bin/sh

SudoPass=$(zenity --password --width=560)
YourIP=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

NetLocate=$(zenity  --list  --text "Choose machine location " --radiolist  --column "Pick" --column "Position" FALSE "Bench Nearest to Main Network Hub and Switches" FALSE "Inner Cabin facing away from glass" FALSE "Inner Cabin facing towards glass") 
#Situation 1, Intranet Crash
nearMachine=$(zenity --entry --text "Enter IP address of physcially closest machine" --entry-text "192.168.1.")
nearHub=192.168.1.15
externalIP=8.8.8.8
nearPing=ping -c1 `echo $nearMachine`
#ping nearest machine
if [ `echo `ping -c1 `echo $nearMachine``` -eq 0 ]
then
nearDown=1
fi

#ping main Hub Machines
while ! ping -c1 `echo $nearHub`
do 
nearDown=2
done        
        
#Both do not work. Escalate to network problem
while ! ping -c1 `echo $externalIP`
do 
nearDown=3
done   

while ping -c1 `echo $externalIP`
do 
nearDown=4
done   

case "$TestType" in
    "1")zenity --info --text " Self Assist: \n Most possible reason include \n <b> Ethernet cable on this computer may be unplugged or loose. </b> \n Check if network cable is loose on Ethernet port. \n Network manager may have crashed. \n Click Ok to restart network manager"
	echo $SudoPass | sudo -S service network-manager stop;;

    "2")zenity --info --text " Admin Optional: Most possible reason include \n <b> Network switch disconnected. </b> \n The network connection may be disconnected to the local switch you are using. Please contact admin and show this message ";;

    "3")zenity --info --text " Contact admin. Network down. Also show this message.";;
    "4")zenity --info --text " LoL. Are you sure there is no network connection.";;
esac


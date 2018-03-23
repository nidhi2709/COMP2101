#!bin/bash
echo "Hello World!" - A simple menu driver shell script to get information about your desktop
#linux server / desktop.
# Author : Nidhi Patel (200359316)
# Date: 03/23/2018

# Defined Variables
 LSB=/usr/bin/lsb_release

 function pause(){
   local message="$@"
   [ -z $message ] && message="Press [Enter] key to continue.."
   read -p "$message" readEntryKey
 }

#Purpose -Display a menu on screen
function show_menu(){
  date
  echo "_ _ _ _ _ _"
  echo"  Main Menu  "
  echo "_ _ _ _ _ _"
  echo "1. Operating system info"
  echo "2. Hostname and dns info"
  echo "3. Network info"

}

# Purpose - Display header messsage
# $1 - messsage
function write_header(){
  local h="$@"
  echo " _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _"
  echo "    ${h}"
  echo " _ _ _ _ _ _ __ _ _ _ __ _ _ _ _ __  _ _"

}

# Purpose - Get info about your operating system
function os_info(){
  write_header " System Information"
  echo "Operating System : $(uname)"
  [ -x $LSB ] && $LSB -a || echo "$LSB command is not installed(set \$LSB variable)"
  # pause "Press [Enter] key to continue..."
  pause
}

#Purpose - Get info about host such as dns, IP, and Hostname
function host_info(){
  local dnsip=$(sed -e '/^$/d' /etc/resolve.conf | awk '{if(tolower($1)=="nameserver") print $2}')
  Write_header " Hostname and DNS information "
  echo "Hostname : $(hostname -s)"
  echo "DNS domain : $(hostname -d)"
  echo "Fully Qualified domain name : $(hostanme -f)"
  echo "Network address (IP) : $(hostanme -i)"
  echo "DNS name servers (DNS IP) : ${dnsip}"
  pause
}

#Purpose - Network interface and routing information
function net_info(){
  devices=$(netstat -i | cut -d" " -f1 | egrep -v"^Kernel|Iface|lo")
  write_header " Network information "
  echo "Total network interfaces found : $(wc -w <<<${devices})"
  echo "*** IP Addresses Information ***"
  ip -4 address show_menu

  echo "*******************"
  echo "*** Network routing ***"
  echo "*******************"
  netstat -nr

  echo "*************************"
  echo "*** Interface traffic information ***"
  echo "*************************"
  netstat -i

  pause
}

# Purpose - Display used and free memory info
function mem_info(){
  write_header " Free and used memory "
  free -m

  echo "**************************"
  echo "*** Virtual memory statistics ***"
  echo "***************************"
  vmstat
  echo "*** Top 5 memory eating process ***"
  echo  "***************************"
  ps auxf | sort -nr -k 4 | head -5
  pause
}

#purpose -Display help options
function help_info(){

  write_header " help "
  echo " ***************************"
  echo " ***help***"
  echo " ***************************"
  vmstat
  echo " ***help***"
  echo " *************************** "
  ps -h |--help
  pause
}

# Purpose - get input via the keyboard and make a decision using case..esac
function read_input(){
  local c
  read -p "Enter your choice [ 1 - 5 ]" c
  case $c in
    1) os_info ;;
    2) host_info ;;
    3) net_info ;;
    4) mem_info ;;
    5) echo "Bye!"; exit 0 ;;
    6) help ;;
    *)
        echo "Please select between 1 to 5 choice only."
        pause

    esac

}

#purpose - cpu information
function cpu_info(){
  write_header " CPU info "
  echo "***********************"
  echo "*** CPU Information***"
  echo "***********************"

  cat /proc/mem_info
}

# ignore CTRL+C, CTRL+Z and quite singles using the trap
trap ' SIGINT SIGQUIT SIGTSTP '

# main logic
while true
do
   clear
   show_menu # display memu
   read_input # wait for user input
done

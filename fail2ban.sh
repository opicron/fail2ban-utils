# BEGIN fail2ban script #
#!/bin/bash
source /etc/bash.d/select.sh

fail2ban() {
# emphasized (bolded) colors
BOLD=$'\033[1m';
COLOR=$'\033[0;33m'
COLOR2=$'\033[0;34m'
WHITE=$'\033[0;37m'
NONE=$'\033[0m'

JAILS=`fail2ban-client status | grep "Jail list" | sed -E 's/^[^:]+:[ \t]+//' | sed 's/,//g'`

IPS=()
for JAIL in $JAILS
do
  #echo
  fail2ban-client status $JAIL | sed -e "s/Status for the jail:/$WHITE$BOLD\Status:$COLOR2$BOLD/;s/failed/fails/;" -e "s/|-/$COLOR|-$NONE/g;s/\`\-/$COLOR\'-$NONE/g;s/|/$COLOR\|/g;"
  echo

  result=`fail2ban-client status $JAIL | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"`
  for IP in $result
  do
    #echo [$IP]
    IPS+=($IP)
  done
done

if [ ${#IPS[@]} -eq 0 ]
  then
    return
fi


for arg in "$@"
do
  if [ "$arg" == "--unban" ] || [ "$arg" == "-u" ]
  then
    #echo ${IPS[*]}
    #for IP in ${IPS[*]}
    #do
    #  echo
    #  echo $IP
    #done

    echo 'Current IPS in jail:'
    echo
    PS3=$'\nChoose IP [#/Enter] to exit # '

    optionsAudits=('No')
    opt=$(selectWithDefault "${IPS[@]}")
    #for item in "${IPS[@]}"; do
    #  if [[ $item == $opt ]]; then
    #    break 2
    #  fi
    #done
    #echo "You have chosen $opt"
    case $opt in
      ''|'No' )
          echo
          return
         ;;
      esac

      for jail in $JAILS; do fail2ban-client set $jail unbanip $opt > /dev/null 2>&1; done

      #echo $opt;
      #if ["$opt" = "Exit"]
      #then
      #  break
      #fi
      #done
      #echo $opt
    fi
done


}
# END fail2ban script #


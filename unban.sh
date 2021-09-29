#!/bin/bash
for jail in $(fail2ban-client status | grep 'Jail list:' | sed 's/.*Jail list://' | sed 's/,//g'); do fail2ban-client set $jail unbanip $1; done

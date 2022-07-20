#! /bin/bash


#generate password
SECRET=$(echo $RANDOM | md5sum | head -c 20; echo)

echo $SECRET

USER=$(shuf -i 2-8 -n 1)

echo $USER

#get company
echo Please enter the PC-name of the company '(This can ve found at REDACTED)'
read company

echo Please enter the media server the client is on '(1,2 or 3)'
read media

#change directory
cd /etc/asterisk/organizations/$company
pwd

#build trunk
echo [$company-bicom-m$media]  >> sip_accounts.conf
echo type=friend  >> sip_accounts.conf
echo username=bicom-$company-m$media >> sip_accounts.conf
echo fromuser=bicom-$company-m$media >> sip_accounts.conf
echo secret=$SECRET >> sip_accounts.conf
echo host=dynamic >> sip_accounts.conf
echo qualify=yes >> sip_accounts.conf
echo disallow=all >> sip_accounts.conf
echo allow=ulaw >> sip_accounts.conf
echo allow=alaw >> sip_accounts.conf
echo allow=gsm >> sip_accounts.conf
echo context=$company >> sip_accounts.conf
echo insecure=port,invite >> sip_accounts.conf
echo dtmfmode=rfc2833 >> sip_accounts.conf
echo call-limit=20 >> sip_accounts.conf
echo trustrpid=yes >> sip_accounts.conf
echo sendrpid=yes >> sip_accounts.conf
echo SETVAR=USERFIELD=${USER}99 >> sip_accounts.conf

asterisk -rx 'sip reload all'


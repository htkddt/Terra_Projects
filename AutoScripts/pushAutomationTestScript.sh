#!/bin/bash

SENDER='harry.nguyen@terralogic.com'
#RECVIVER='sang.nguyen@terralogic.com'
RECVIVER='harry.nguyen@terralogic.com'
GAPP='Thang1234@@'

GGSHETFILE=''

REGEX_TST_FILE='^squish_test_suites\/.*test\.js$'

COUNTER=0
LIST_SCRIPT_CHANGE=""


####################################
## START DEFINE FUNCTION ##
####################################
# sendEmail $sub $body
sendEmail () {
	sub=$1
	body=$2
	# curl command for accessing the smtp server
	curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
	--mail-from $SENDER \
	--mail-rcpt $RECVIVER\
	--user $SENDER:$GAPP \
	 -T <(echo -e "From: ${SENDER}
To: ${RECVIVER}
Subject:${sub}
${body}")
}


####################################
## END DEFINE FUNCTION ##
####################################


# list all file change
while read l1 ;do 
   if [[ $l1 =~ $REGEX_TST_FILE ]];then 
		#echo $l1
		COUNTER=$(( COUNTER + 1 ))
		LIST_SCRIPT_CHANGE+='- '
		LIST_SCRIPT_CHANGE+=$l1
		LIST_SCRIPT_CHANGE+='\n'
   fi
done < <(git diff --name-only)


echo "number script file update: " $COUNTER
echo -e $LIST_SCRIPT_CHANGE

#send email
SUB='Test send email from bash script'
BODY='abc xyz'
sendEmail $SUB $BODY

#update to gg sheet



#turnin

# $HOME/${USER}
# echo "testing message" | mail -s "message subject" harry.nguyen@terralogic.com

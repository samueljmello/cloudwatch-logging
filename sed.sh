#!/bin/bash -ex

#-------------------------------------------------------------------------------#
# NOTES: Script was used to edit only. Actual implementation is in CF template. #
#-------------------------------------------------------------------------------#

# make backup of apache config
sudo cp -f /etc/httpd/conf/httpd.conf ~/httpd.back.conf

# set up vars - don't forget proper escaping
FILE="/etc/httpd/conf/httpd.conf";

ELOG='ErrorLog "logs\/error_log"';
ELOGREP='ErrorLog "\/var\/log\/www\/error\/error_log"';
ELOGFMT='ErrorLogFormat "{\\"time\\":\\"%{%usec_frac}t\\", \\"function\\" : \\"[%-m:%l]\\", \\"process\\" : \\"[pid%P]\\" ,\\"message\\" : \\"%M\\"}"';

CLOG='CustomLog "logs\/access_log" combined'
CLOGFMT='LogFormat "%h %l %u %t \\"%r\\" %>s %b" common';

CWLOG='CustomLog "\/var\/log\/www\/access\/access_log" cloudwatch';
CWLOGFMT='LogFormat "{ \\"time\\":\\"%{%Y-%m-%d}tT%{%T}t.%{msec_frac}tZ\\", \\"process\\":\\"%D\\", \\"filename\\":\\"%f\\", \\"remoteIP\\":\\"%a\\", \\"host\\":\\"%V\\", \\"request\\":\\"%U\\", \\"query\\":\\"%q\\",\\"method\\":\\"%m\\", \\"status\\":\\"%>s\\", \\"userAgent\\":\\"%{User-agent}i\\",\\"referer\\":\\"%{Referer}i\\"}" cloudwatch';

# modify with sed and write using dd
sed "s/${ELOG}/${ELOGREP}/g" ${FILE} |\
    sed "/${ELOGREP}/a ${ELOGFMT}" |\
    sed "s/${CLOGFMT}/${CWLOGFMT}/g" |\
    sed "/${CLOG}/a ${CWLOG}" |\
    sudo dd of=${FILE};

# make folders if they don't exist
sudo mkdir -p /var/log/www/error
sudo mkdir -p /var/log/www/access

# restart apache
sudo systemctl restart httpd
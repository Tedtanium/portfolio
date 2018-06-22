#!/bin/bash

#This scriptlet sends logs to the rsyslog server. RSYSLOGIP must be replaced with the server's internal IP address.

echo "*.info;mail.none;authpriv.none;cron.none   @RSYSLOGIP" >> /etc/rsyslog.conf && systemctl restart rsyslog.service

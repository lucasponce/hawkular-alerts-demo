create_msg () {
	TIMESTAMP=$(date +%s%3N)
	VALUE="DOWN"
	if [ $1 -gt 0 ]
	then
		VALUE="UP"
	fi
	MSG="["
	MSG="$MSG{"
	MSG="$MSG\"id\":\"demo-avail\","
	MSG="$MSG\"timestamp\":$TIMESTAMP,"
	MSG="$MSG\"value\":\"$VALUE\""	
	MSG="$MSG}"	
	MSG="$MSG]"
	echo $MSG
}

send_data () {
	MSG=$(create_msg $1)
	TENANT="my-organization"
	CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST --header "Hawkular-Tenant: $TENANT" --header "Content-Type:application/json" --data "$MSG" http://localhost:8080/hawkular/alerts/data)
	echo "Sent data [$CODE]"
	echo "$MSG"
	echo ""
	return 0
}

while :
do
	NUM_SERVERS=$(ps -ef | grep java | grep 'port-offset=150' | wc -l)
	send_data $NUM_SERVERS
	sleep 2s
done

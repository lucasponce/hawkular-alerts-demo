create_event () {
	ID=$(uuidgen)
	TIMESTAMP=$(date +%s%3N)
	DATA_ID="demo-log"
	CATEGORY="LOG"
	DETECT_DEPLOYMENT=$(echo "$@" | grep "WFLYSRV00[01][09]" | wc -l)
	if [ $DETECT_DEPLOYMENT -gt 0 ]
	then
		CATEGORY="DEPLOYMENT"
	fi
	TEXT=$(echo $@ | sed -e 's/\"/\\\"/g')
	EVT="["
	EVT="$EVT{"
	EVT="$EVT\"id\":\"$ID\","
	EVT="$EVT\"ctime\":$TIMESTAMP,"
	EVT="$EVT\"dataId\":\"$DATA_ID\","
	EVT="$EVT\"category\":\"$CATEGORY\","
	EVT="$EVT\"text\":\"$TEXT\","
	EVT="$EVT\"tags\":{\"level\":\"$3\"}"
	EVT="$EVT}"
	EVT="$EVT]"	
	echo $EVT
}	

send_event () {
	MSG=$(create_event $@)	
	TENANT="my-organization"
	CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST --header "Hawkular-Tenant: $TENANT" --header "Content-Type:application/json" --data "$MSG" http://localhost:8080/hawkular/alerts/events/data)
	echo "Sent event [$CODE]"
	echo "$MSG"
	echo ""
	return 0
}

tail -F wildfly-10.1.0.Final/standalone/log/server.log | while read LOG ; do send_event $LOG; done

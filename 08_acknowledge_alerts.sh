TENANT="my-organization"
OPEN_ALERTS=$(curl -s -X GET \
--header "Hawkular-Tenant: $TENANT" \
http://localhost:8080/hawkular/alerts?statuses=OPEN)
PYTHON_PARSER="import sys, json; print ','.join([a['id'] for a in json.load(sys.stdin)])"

ALERT_IDS=$(echo $OPEN_ALERTS | python -c "$PYTHON_PARSER")
ACK_BY="08_acknowledge_alerts.sh"
ACK_NOTES="ACK from script"

CODE=$(curl -G -s -o /dev/null -w "%{http_code}" -X PUT \
--header "Hawkular-Tenant: $TENANT" \
--header "Content-Type:application/json" \
--data-urlencode alertIds="$ALERT_IDS" \
--data-urlencode ackBy="$ACK_BY" \
--data-urlencode ackNotes="$ACK_NOTES" \
http://localhost:8080/hawkular/alerts/ack)

echo "Acknowledging $ALERT_IDS [$CODE]"

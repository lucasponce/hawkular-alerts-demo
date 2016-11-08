TENANT="my-organization"
ACKNOWLEDGED_ALERTS=$(curl -s -X GET \
--header "Hawkular-Tenant: $TENANT" \
http://localhost:8080/hawkular/alerts?statuses=ACKNOWLEDGED)

PYTHON_PARSER="import sys, json; print ','.join([a['id'] for a in json.load(sys.stdin)])"

ALERT_IDS=$(echo $ACKNOWLEDGED_ALERTS | python -c "$PYTHON_PARSER")
RESOLVED_BY="09_resolve_alerts.sh"
RESOLVED_NOTES="RESOLVED from script"

CODE=$(curl -G -s -o /dev/null -w "%{http_code}" -X PUT \
--header "Hawkular-Tenant: $TENANT" \
--header "Content-Type:application/json" \
--data alertIds="$ALERT_IDS" \
--data-urlencode resolvedBy="$RESOLVED_BY" \
--data-urlencode resolvedNotes="$RESOLVED_NOTES" \
http://localhost:8080/hawkular/alerts/resolve?alertsIds=$ALERTS_IDS)

echo "Resolving $ALERT_IDS [$CODE]"

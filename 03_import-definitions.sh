TENANT="my-organization"

function import_definitions() {
	CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
	--header "Hawkular-Tenant: $TENANT" \
	--header "Content-Type:application/json" \
	--data-binary "@$1" \
	http://localhost:8080/hawkular/alerts/import/all)
	echo "Imported $1 with code [$CODE]"
	return 0
}

import_definitions "03_import-definitions/import-actions.json"
import_definitions "03_import-definitions/import-availability.json"
import_definitions "03_import-definitions/import-deployments.json"
import_definitions "03_import-definitions/import-applications.json"

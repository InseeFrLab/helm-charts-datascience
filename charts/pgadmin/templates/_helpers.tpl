{{/* vim: set filetype=mustache: */}}

{{- define "pgadmin.configmap" -}}
{{ printf "{" }}
{{ printf "\"Servers\": {" | indent 2 }} 
{{- $virgule := 0 }}      
{{ range $index, $service := (lookup "v1" "Service" .Release.Namespace "").items }}
{{- if (index $service "metadata" "labels") }}
{{- if (index $service "metadata" "labels" "helm.sh/chart") }}
{{- if hasPrefix "postgres" (index $service "metadata" "labels" "helm.sh/chart") }}
{{- if $virgule }}
{{ printf "," }}
{{- end }}
{{ printf "\"%d\" :{" $index | indent 4}}
{{ printf "\"Name\": \"%s\"," $service.metadata.name | indent 6}}
{{ printf "\"Group\": \"Autodiscovery\"," | indent 6}}
{{ printf "\"Port\": %d," (index $service.spec.ports 0).port | indent 6}}
{{ printf "\"Host\": \"%s\"," $service.metadata.name | indent 6}}
{{ printf "\"Username\": \"%s\"," (trimPrefix "user-" $service.metadata.namespace) | indent 6}}
{{ printf "\"SSLMode\": \"prefer\"," | indent 6 }}
{{ printf "\"MaintenanceDB\": \"postgres\"" | indent 6}}
{{- $virgule = 1}}
{{ printf "}" | indent 4}}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{ printf "}" | indent 2}}
{{ printf "}" }}
{{- end }}

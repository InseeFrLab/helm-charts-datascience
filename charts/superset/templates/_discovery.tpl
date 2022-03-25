{{/* vim: set filetype=mustache: */}}
  #     databases:
  #     - allow_file_upload: true
  #       allow_ctas: true
  #       allow_cvas: true
  #       database_name: example-db
  #       extra: "{\r\n    \"metadata_params\": {},\r\n    \"engine_params\": {},\r\n    \"\
  #         metadata_cache_timeout\": {},\r\n    \"schemas_allowed_for_file_upload\": []\r\n\
  #         }"
  #       sqlalchemy_uri: example://example-db.local
  #       tables: []
{{/*
Create the name of the config map S3 to use
*/}}
{{- define "superset.discovery" -}}
{{ $postgres:= .Values.discovery.postgres }}
{{ $trino:= .Values.discovery.trino }}
{{ $namespace:= .Release.Namespace }}
{{- range $index, $secret := (lookup "v1" "Secret" $namespace "").items }}
{{- if (index $secret "metadata" "annotations") }}
{{- if and (index $secret "metadata" "annotations" "onyxia/discovery") (eq "postgres" (index $secret "metadata" "annotations" "onyxia/discovery" | toString)) }}
{{ $service:= ( index $secret.data "postgres-service" | default "") | b64dec  }}
{{ $username:= ( index $secret.data "postgres-username") | b64dec  }}
{{ $password:= ( index $secret.data "postgres-password") | b64dec  }}
{{ $database:= ( index $secret.data "postgres-database") | b64dec  }}
{{ $port:= ( index $secret.data "postgres-port") }}
{{ $data := dict "postgres" $postgres "service" $service  "index" $index "username" $username "password" $password "database" $database "port" $port}}
{{- template "superset.postgres" $data -}}
{{- end -}}
{{- if and (index $secret "metadata" "annotations" "onyxia/discovery") (eq "trino" (index $secret "metadata" "annotations" "onyxia/discovery" | toString)) }}
{{ $service:= ( index $secret.data "trino-service" | default "") | b64dec  }}
{{ $username:= ( index $secret.data "trino-username") | b64dec  }}
{{ $password:= ( index $secret.data "trino-password") | b64dec  }}
{{ $database:= ( index $secret.data "trino-database") | b64dec  }}
{{ $port:= ( index $secret.data "trino-port") | b64dec  }}
{{ $data := dict "trino" $trino "service" $service  "index" $index "username" $username "password" $password "database" $database "port" $port}}
{{- template "superset.trino" $data -}}
{{- end -}}
{{- end -}}
{{- end -}} 
{{- end -}} 

{{- define "superset.postgres" -}}
{{ $postgres:= .postgres }}
{{ $service:= .service }}
{{ $index:= .index }}
{{ $port:= .port }}
{{ $username:= .username }}
{{ $password:= .password }}
{{ $database:= .database }}
{{- if $postgres }}
{{- printf "- allow_file_upload: true"| indent 2}}
{{ printf "allow_ctas: true"| indent 4}}
{{ printf "allow_cvas: true"| indent 4}}
{{ printf "database_name: %s" $service | indent 4}}
{{ printf "sqlalchemy_uri: postgresql://%s:%s/%s?user=%s&password=%s" $service $port $database $username $password | indent 4}}
{{ printf "tables: []" | indent 4}}
{{- end }}
{{- end -}} 

{{- define "superset.trino" -}}
{{ $trino:= .trino }}
{{ $service:= .service }}
{{ $index:= .index }}
{{ $port:= .port }}
{{ $username:= .username }}
{{ $password:= .password }}
{{ $database:= .database }}
{{- if $trino }}
{{- printf "- allow_file_upload: true"| indent 2}}
{{ printf "allow_ctas: true"| indent 4}}
{{ printf "allow_cvas: true"| indent 4}}
{{ printf "database_name: %s-%s" $database $service | indent 4}}
{{ printf "sqlalchemy_uri: trino://%s:%s/%s?username=%s&password=%s" $service $port $database $username $password | indent 4}}
{{ printf "tables: []" | indent 4}}
{{- end }}
{{- end -}} 


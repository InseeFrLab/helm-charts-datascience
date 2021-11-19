{{- define "debug.var_dump" -}}
{{- . | mustToPrettyJson | printf "\nThe JSON output of the dumped var is: \n%s" | fail }}
{{- end -}}

{{- define "connector.postgres" -}}
{{ $postgres:= .postgres }}
{{ $service:= .service }}
{{ $index:= .index }}
{{ $username:= .username }}
{{ $password:= .password }}
{{ $labels:= index $service "metadata" "labels" "helm.sh/chart" }}
{{- if and $postgres (and (not (contains "headless" $service.metadata.name )) (hasPrefix "postgresql" $labels)) }}
{{- printf "postgresql%d.properties: |" $index | indent 2}}
    connector.name=postgresql
{{ printf "connection-url=jdbc:postgresql://%s:5432/%s"  $service.metadata.name "defaultdb"| indent 4}}
{{ printf "connection-user=%s"  $username | indent 4}}
{{ printf "connection-password=%s" $password| indent 4}}
{{- end }}
{{- end -}}

{{- define "connector.hive" -}}
{{ $hive:= .hive }}
{{ $service:= .service }}
{{ $namespace:= .namespace }}
{{ $index:= .index }}
{{ $endpoint:= .endpoint}}
{{- if and $hive (hasPrefix "hive-metastore" (index $service "metadata" "labels" "helm.sh/chart")) }}
{{- printf "hive%d.properties: |" $index | indent 2}}
    connector.name=hive
    hive.config.resources=/etc/trino/hdfs/core-site.xml
{{ printf "hive.metastore.uri=thrift://%s:9083" $service.metadata.name | indent 4}}
{{ printf "hive.s3.endpoint=%s" $endpoint | indent 4 }}
    hive.non-managed-table-writes-enabled=true
{{- end }}
{{- end -}}

{{- define "connector.mongodb" -}}
{{ $mongodb:= .mongodb }}
{{ $service:= .service }}
{{ $namespace:= .namespace }}
{{ $index:= .index }}
{{ $username:= .username }}
{{ $password:= .password }}
{{- if and $mongodb (hasPrefix "mongodb" (index $service "metadata" "labels" "helm.sh/chart")) }}
{{- $mongoList := list }}
{{- if (index $service "metadata" "labels" "app.kubernetes.io/component") }}
{{- if eq "mongodb" (index $service "metadata" "labels" "app.kubernetes.io/component") }}
{{ range $indexPod, $pod := (lookup "v1" "Pod" $namespace "").items }}
{{- if (index $pod "metadata" "labels" "app.kubernetes.io/component") }}
{{- if eq "mongodb" (index $pod "metadata" "labels" "app.kubernetes.io/component") }}
{{- $mongoList = append $mongoList (printf "%s.%s" $pod.metadata.name $service.metadata.name) }}
{{- end }}
{{- end }}
{{- end }}
{{- printf "mongodb%d.properties: |" $index | indent 2}}
    connector.name=mongodb
{{ printf "mongodb.seeds=%s"  (join "," $mongoList) | indent 4}}
{{ printf "mongodb.credentials=%s:%s@%s" $username $password "defaultdb"  | indent 4}}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}


{{- define "connector.elastic" -}}
{{ $elastic:= .elastic }}
{{ $service:= .service }}
{{ $index:= .index }}
{{- if and $elastic (and (not (contains "headless" $service.metadata.name )) (hasPrefix "elasticsearch" $service.metadata.name)) }}
{{- printf "elastic%d.properties: |" $index | indent 2}}
    connector.name=elasticsearch
{{ printf "elasticsearch.host=%s"  $service.metadata.name | indent 4}}
{{ printf "elasticsearch.port=%s"  "9200" | indent 4}}
{{ printf "elasticsearch.default-schema-name=%s" "default"| indent 4}}
{{- end }}
{{- end -}}
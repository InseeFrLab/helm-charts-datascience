{{- define "debug.var_dump" -}}
{{- . | mustToPrettyJson | printf "\nThe JSON output of the dumped var is: \n%s" | fail }}
{{- end -}}

{{- define "connector.postgres" -}}
{{ $postgres:= .postgres }}
{{ $service:= .service }}
{{ $index:= .index }}
{{ $port:= .port }}
{{ $username:= .username }}
{{ $password:= .password }}
{{ $database:= .database }}
{{- if $postgres }}
{{- printf "postgresql%d.properties: |" $index | indent 2}}
    connector.name=postgresql
{{ printf "connection-url=jdbc:postgresql://%s:%s/%s"  $service $port $database | indent 4}}
{{ printf "connection-user=%s"  $username | indent 4}}
{{ printf "connection-password=%s" $password | indent 4}}
{{- end }}
{{- end -}}

{{- define "connector.hive" -}}
{{ $hive:= .hive }}
{{ $service:= .service }}
{{ $index:= .index }}
{{ $endpoint:= .endpoint}}
{{- if $hive  }}
{{- printf "hive.properties: |" | indent 2}}
    connector.name=hive
    hive.config.resources=/etc/trino/hdfs/core-site.xml
{{ printf "hive.metastore.uri=thrift://%s:9083" $service | indent 4}}
{{ printf "hive.s3.endpoint=%s" $endpoint | indent 4 }}
    hive.non-managed-table-writes-enabled=true
{{ printf "iceberg.properties: |" | indent 2}}
    connector.name=iceberg
    hive.config.resources=/etc/trino/hdfs/core-site.xml
{{ printf "hive.metastore.uri=thrift://%s:9083" $service | indent 4}}
{{ printf "hive.s3.endpoint=%s" $endpoint | indent 4 }}
    hive.non-managed-table-writes-enabled=true
{{ printf "deltalake.properties: |" | indent 2}}
    connector.name=delta-lake
    hive.config.resources=/etc/trino/hdfs/core-site.xml
{{ printf "hive.metastore.uri=thrift://%s:9083" $service | indent 4}}
{{ printf "hive.s3.endpoint=%s" $endpoint | indent 4 }}
    hive.non-managed-table-writes-enabled=true
{{- end }}
{{- end -}}

{{- define "connector.mongodb2" -}}
{{ $mongodb:= .mongodb }}
{{ $service:= .service }}
{{ $index:= .index }}
{{ $username:= .username }}
{{ $password:= .password }}
{{ $database:= .database }}
{{ $name:= .name }}
{{ if $mongodb }}
{{- printf "%s.properties: |" $name | indent 2}}
    connector.name=mongodb
{{ printf "mongodb.seeds=%s"  (join "," $service) | trim | indent 4}}
{{ printf "mongodb.credentials=%s:%s@%s" $username $password $database  | indent 4}}
{{- end -}}
{{- end -}}


{{- define "connector.elastic" -}}
{{ $elastic:= .elastic }}
{{ $service:= .service }}
{{ $index:= .index }}
{{ $port:= .port }}
{{- if $elastic }}
{{- printf "%s.properties: |" $service | indent 2}}
    connector.name=elasticsearch
{{ printf "elasticsearch.host=%s"  $service | indent 4}}
{{ printf "elasticsearch.port=%s"  $port | indent 4}}
{{ printf "elasticsearch.default-schema-name=%s" "default"| indent 4}}
{{- end }}
{{- end -}}
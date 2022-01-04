{{- define "kafkaList" -}}
{{- $replicaCount := int .Values.kafka.replicaCount }}
{{- $portNumber := int .Values.kafka.service.port }}
{{- $fullname := include "library-chart.fullname" . }}
{{- $kafkaList := list }}
{{- range $e, $i := until $replicaCount }}
{{- $kafkaList = append $kafkaList (printf "%s-%d.%s-headless:%d" $fullname $i $fullname $portNumber) }}
{{- end }}
{{- printf "%s"  (join "," $kafkaList) -}}
{{- end }}

{{- define "mongoList" -}}
{{- $replicaCount := int .Values.mongodb.replicaCount }}
{{- $portNumber := int .Values.mongodb.service.port }}
{{- $fullname := include "library-chart.fullname" . }}
{{- $mongoList := list }}
{{- range $e, $i := until $replicaCount }}
{{- $mongoList = append $mongoList (printf "%s-%d.%s-headless:%d" $fullname $i $fullname $portNumber) }}
{{- end }}
{{- printf "%s"  (join "," $mongoList) -}}
{{- end }}

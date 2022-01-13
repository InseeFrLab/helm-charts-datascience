{{/* vim: set filetype=mustache: */}}

{{/*
ingress annotations 
*/}}
{{- define "library-chart.ingress.annotations" -}}
{{- with .Values.ingress.annotations }}
    {{- toYaml . }}
{{- end }}
{{- if .Values.security.allowlist.enabled }}
nginx.ingress.kubernetes.io/whitelist-source-range: {{ .Values.security.allowlist.ip }}
{{- end }}
{{- end }}

{{- define "library-chart.ingress.hostname" -}}
{{- if .Values.ingress.generate }}
{{- printf "%s" .Values.ingress.userHostname }}
{{- else }}
{{- printf "%s" .Values.ingress.hostname }}
{{- end }}
{{- end }}

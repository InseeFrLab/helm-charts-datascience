{{/* vim: set filetype=mustache: */}}

{{/*
Common labels
*/}}
{{- define "library-chart.labels" -}}
helm.sh/chart: {{ include "library-chart.chart" . }}
{{ include "library-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "library-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "library-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Values.tags.enabled }}
{{- if .Values.tags.filtertag1 }}
filtertag1: {{ .Values.tags.filtertag1 | quote }}
{{- end }}
{{- if .Values.tags.filtertag2 }}
filtertag2: {{ .Values.tags.filtertag2 | quote }}
{{- end }}
{{- if .Values.tags.filtertag3 }}
filtertag3: {{ .Values.tags.filtertag3 | quote }}
{{- end }}
{{- end }}
{{- end }}

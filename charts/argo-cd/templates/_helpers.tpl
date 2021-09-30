{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "argo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "argo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Create argocd server name and version as used by the chart label.
*/}}
{{- define "argo.server.fullname" -}}
{{- printf "%s-%s" (include "argo-cd.fullname" .) (index .Values "argo-cd" "server" "name") | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create controller name and version as used by the chart label.
*/}}
{{- define "argo.controller.fullname" -}}
{{- printf "%s-%s" (include "argo-cd.fullname" .) (index .Values "argo-cd" "controller" "name") | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the controller service account to use
*/}}
{{- define "argo.controllerServiceAccountName" -}}
{{- if (index .Values "argo-cd" "controller" "serviceAccount" "create") -}}
    {{ default (include "argo.controller.fullname" .) (index .Values "argo-cd" "controller" "serviceAccount" "name") }}
{{- else -}}
    {{ default "default" (index .Values "argo-cd" "controller" "serviceAccount" "name") }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the ArgoCD server service account to use
*/}}
{{- define "argo.serverServiceAccountName" -}}
{{- if (index .Values "argo-cd" "server" "serviceAccount" "create") -}}
    {{ default (include "argo.server.fullname" .) (index .Values "argo-cd" "server" "serviceAccount" "name") }}
{{- else -}}
    {{ default "default" (index .Values "argo-cd" "server" "serviceAccount" "name") }}
{{- end -}}
{{- end -}}

{{- define "argo.labels" -}}
helm.sh/chart: {{ include "argo.chart" . }}
{{ include "argo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "argo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "argo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ingress annotations 
*/}}
{{- define "argo.ingress.annotations" -}}
{{- with .Values.ingress.annotations }}
    {{- toYaml . }}
{{- end }}
{{- if .Values.ingress.security.whitelist.enabled }}
nginx.ingress.kubernetes.io/whitelist-source-range: {{ .Values.ingress.security.whitelist.ip }}
{{- end }}
{{- end }}

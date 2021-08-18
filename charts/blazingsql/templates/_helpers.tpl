{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "blazingsql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "blazingsql.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "blazingsql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "blazingsql.labels" -}}
helm.sh/chart: {{ include "blazingsql.chart" . }}
{{ include "blazingsql.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "blazingsql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "blazingsql.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "blazingsql.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "blazingsql.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



{{/*
Create the name of the config map S3 to use
*/}}
{{- define "blazingsql.configMapNameS3" -}}
{{- if .Values.s3.enabled }}
{{- $name:= (printf "%s-configmaps3" (include "blazingsql.fullname" .) )  }}
{{- default $name .Values.s3.configMapName }}
{{- else }}
{{- default "default" .Values.s3.configMapName }}
{{- end }}
{{- end }}

{{/*
Create the name of the config map Vault to use
*/}}
{{- define "blazingsql.configMapNameVault" -}}
{{- if .Values.vault.enabled }}
{{- $name:= (printf "%s-configmapvault" (include "blazingsql.fullname" .) )  }}
{{- default $name .Values.vault.configMapName }}
{{- else }}
{{- default "default" .Values.vault.configMapName }}
{{- end }}
{{- end }}

{{/*
Create the name of the config map Git to use
*/}}
{{- define "blazingsql.configMapNameGit" -}}
{{- if .Values.git.enabled }}
{{- $name:= (printf "%s-configmapgit" (include "blazingsql.fullname" .) )  }}
{{- default $name .Values.git.configMapName }}
{{- else }}
{{- default "default" .Values.git.configMapName }}
{{- end }}
{{- end }}

{{/*
ingress annotations 
*/}}
{{- define "blazingsql.ingress.annotations" -}}
{{- with .Values.ingress.annotations }}
    {{- toYaml . }}
{{- end }}
{{- if .Values.security.allowlist.enabled }}
nginx.ingress.kubernetes.io/whitelist-source-range: {{ .Values.security.allowlist.ip }}
{{- end }}
{{- end }}

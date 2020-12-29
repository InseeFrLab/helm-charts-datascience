{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "openrefine.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openrefine.fullname" -}}
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
{{- define "openrefine.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "openrefine.labels" -}}
helm.sh/chart: {{ include "openrefine.chart" . }}
{{ include "openrefine.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "openrefine.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openrefine.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "openrefine.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "openrefine.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



{{/*
Create the name of the config map S3 to use
*/}}
{{- define "openrefine.configMapNameS3" -}}
{{- if .Values.s3.create }}
{{- $name:= (printf "%s-configmaps3" (include "openrefine.fullname" .) )  }}
{{- default $name .Values.s3.configMapName }}
{{- else }}
{{- default "default" .Values.s3.configMapName }}
{{- end }}
{{- end }}

{{/*
Create the name of the config map Vault to use
*/}}
{{- define "openrefine.configMapNameVault" -}}
{{- if .Values.vault.create }}
{{- $name:= (printf "%s-configmapvault" (include "openrefine.fullname" .) )  }}
{{- default $name .Values.vault.configMapName }}
{{- else }}
{{- default "default" .Values.vault.configMapName }}
{{- end }}
{{- end }}

{{/*
Create the name of the config map Git to use
*/}}
{{- define "openrefine.configMapNameGit" -}}
{{- if .Values.vault.create }}
{{- $name:= (printf "%s-configmapgit" (include "openrefine.fullname" .) )  }}
{{- default $name .Values.git.configMapName }}
{{- else }}
{{- default "default" .Values.git.configMapName }}
{{- end }}
{{- end }}

{{/*
ingress annotations 
*/}}
{{- define "openrefine.ingress.annotations" -}}
{{- with .Values.ingress.annotations }}
    {{- toYaml . }}
{{- end }}
{{- if .Values.security.whitelist.enable }}
nginx.ingress.kubernetes.io/whitelist-source-range: {{ .Values.security.whitelist.ip }}
{{- end }}
{{- end }}
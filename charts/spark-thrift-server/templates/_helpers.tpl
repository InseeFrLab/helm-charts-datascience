{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "spark-thrift-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "spark-thrift-server.fullname" -}}
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
{{- define "spark-thrift-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "spark-thrift-server.labels" -}}
helm.sh/chart: {{ include "spark-thrift-server.chart" . }}
{{ include "spark-thrift-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "spark-thrift-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "spark-thrift-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "spark-thrift-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "spark-thrift-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



{{/*
Create the name of the config map S3 to use
*/}}
{{- define "spark-thrift-server.configMapNameS3" -}}
{{- if .Values.s3.create }}
{{- $name:= (printf "%s-configmaps3" (include "spark-thrift-server.fullname" .) )  }}
{{- default $name .Values.s3.configMapName }}
{{- else }}
{{- default "default" .Values.s3.configMapName }}
{{- end }}
{{- end }}

{{/*
Create the name of the config map Vault to use
*/}}
{{- define "spark-thrift-server.configMapNameVault" -}}
{{- if .Values.vault.create }}
{{- $name:= (printf "%s-configmapvault" (include "spark-thrift-server.fullname" .) )  }}
{{- default $name .Values.vault.configMapName }}
{{- else }}
{{- default "default" .Values.vault.configMapName }}
{{- end }}
{{- end }}

{{/*
Create the name of the config map Git to use
*/}}
{{- define "spark-thrift-server.configMapNameGit" -}}
{{- if .Values.vault.create }}
{{- $name:= (printf "%s-configmapgit" (include "spark-thrift-server.fullname" .) )  }}
{{- default $name .Values.git.configMapName }}
{{- else }}
{{- default "default" .Values.git.configMapName }}
{{- end }}
{{- end }}

{{/*
ingress annotations 
*/}}
{{- define "spark-thrift-server.ingress.annotations" -}}
{{- with .Values.ingress.annotations }}
    {{- toYaml . }}
{{- end }}
{{- if .Values.security.whitelist.enable }}
nginx.ingress.kubernetes.io/whitelist-source-range: {{ .Values.security.whitelist.ip }}
{{- end }}
{{- end }}



{{- define "hiveMetastore.configmap" -}}
{{ printf "<?xml version=\"1.0\"?>" }}
{{ printf "<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>" }} 
{{ printf "<configuration>"}}
{{- $virgule := 0 }}      
{{ range $index, $service := (lookup "v1" "Service" .Release.Namespace "").items }}
{{- if (index $service "metadata" "labels" "helm.sh/chart") }}
{{- if hasPrefix "hive-metastore" (index $service "metadata" "labels" "helm.sh/chart") }}
{{- if $virgule }}
{{- end }}
{{ printf "<property>"}}
{{ printf "<name>hive.metastore.uris</name>"  | indent 4}}
{{ printf "<value>thrift://%s:9083</value>" $service.metadata.name | indent 4}}
{{ printf "</property>"}}
{{- $virgule = 1}}
{{- end }}
{{- end }}
{{- end }}
{{ printf "</configuration>"}}
{{- end }}

{{/*
Create the name of the config map hive to use
*/}}
{{- define "spark-thrift-server.configMapNameHive" -}}
{{- if .Values.discovery.hive }}
{{- $name:= (printf "%s-configmaphive" (include "jupyter.fullname" .) )  }}
{{- default $name .Values.hive.configMapName }}
{{- else }}
{{- default "default" .Values.hive.configMapName }}
{{- end }}
{{- end }}
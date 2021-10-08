{{/* vim: set filetype=mustache: */}}

{{/*
Create the name of the config map S3 to use
*/}}
{{- define "library-chart.configMapNameS3" -}}
{{- if .Values.s3.enabled }}
{{- $name:= (printf "%s-configmaps3" (include "library-chart.fullname" .) )  }}
{{- default $name .Values.s3.configMapName }}
{{- else }}
{{- default "default" .Values.s3.configMapName }}
{{- end }}
{{- end }}

{{/*
Template to generate a ConfigMap for S3
*/}}
{{- define "library-chart.configMapS3" -}}
{{- if .Values.s3.enabled -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "library-chart.configMapNameS3" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
data:
  AWS_ACCESS_KEY_ID: "{{ .Values.s3.accessKeyId }}"
  AWS_S3_ENDPOINT: "{{ .Values.s3.endpoint }}"
  AWS_DEFAULT_REGION: "{{ .Values.s3.defaultRegion }}"
  AWS_SECRET_ACCESS_KEY: "{{ .Values.s3.secretAccessKey }}"
  AWS_SESSION_TOKEN: "{{ .Values.s3.sessionToken }}"
{{- end }}
{{- end }}

{{/*
Create the name of the config map Vault to use
*/}}
{{- define "library-chart.configMapNameVault" -}}
{{- if .Values.vault.enabled }}
{{- $name:= (printf "%s-configmapvault" (include "library-chart.fullname" .) )  }}
{{- default $name .Values.vault.configMapName }}
{{- else }}
{{- default "default" .Values.vault.configMapName }}
{{- end }}
{{- end }}

{{/*
Template to generate a ConfigMap for Vault
*/}}
{{- define "library-chart.configMapVault" -}}
{{- if .Values.vault.enabled -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "library-chart.configMapNameVault" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
data:
  VAULT_ADDR: "{{ .Values.vault.url }}"
  VAULT_TOKEN: "{{ .Values.vault.token }}"
  VAULT_RELATIVE_PATH: "{{ .Values.vault.secret }}"
  VAULT_TOP_DIR: "{{ .Values.vault.directory }}"
  VAULT_MOUNT: "{{ .Values.vault.mount }}"
{{- end }}
{{- end }}

{{/*
Create the name of the config map Git to use
*/}}
{{- define "library-chart.configMapNameGit" -}}
{{- if .Values.git.enabled }}
{{- $name:= (printf "%s-configmapgit" (include "library-chart.fullname" .) )  }}
{{- default $name .Values.git.configMapName }}
{{- else }}
{{- default "default" .Values.git.configMapName }}
{{- end }}
{{- end }}

{{/*
Template to generate a ConfigMap for git
*/}}
{{- define "library-chart.configMapGit" -}}
{{- if .Values.git.enabled -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "library-chart.configMapNameGit" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
data:
  GIT_USER_NAME: "{{ .Values.git.name }}"
  GIT_USER_MAIL: "{{ .Values.git.email }}"
  GIT_CREDENTIALS_CACHE_DURATION: "{{ .Values.git.cache }}"
  GIT_PERSONNAL_ACCESS_TOKEN: "{{ .Values.git.token }}"
  GIT_REPOSITORY: "{{ .Values.git.repository }}"
{{- end }}
{{- end }}

{{/*
ConfigMap for Hive Metastore
*/}}
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
Create the name of the config map Hive to use
*/}}
{{- define "library-chart.configMapNameHive" -}}
{{- if .Values.discovery.hive }}
{{- $name:= (printf "%s-configmaphive" (include "library-chart.fullname" .) )  }}
{{- default $name .Values.hive.configMapName }}
{{- else }}
{{- default "default" .Values.hive.configMapName }}
{{- end }}
{{- end }}

{{/*
Template to generate a ConfigMap for Hive
*/}}
{{- define "library-chart.configMapHive" -}}
{{- if .Values.discovery.hive -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "library-chart.fullname" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
data:
  hive-site.xml: |
    {{- include "hiveMetastore.configmap" . | nindent 4 }}
{{- end }}
{{- end }}

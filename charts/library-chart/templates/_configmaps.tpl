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
  S3_ENDPOINT: "https://{{ .Values.s3.endpoint }}/"
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
  GIT_PERSONAL_ACCESS_TOKEN: "{{ .Values.git.token }}"
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
{{ range $index, $service := (lookup "v1" "Service" .Release.Namespace "").items }}
{{- if (index $service "metadata" "labels") }}
{{- if (index $service "metadata" "labels" "helm.sh/chart") }}
{{- if hasPrefix "hive-metastore" (index $service "metadata" "labels" "helm.sh/chart") }}
{{ printf "<property>"}}
{{ printf "<name>hive.metastore.uris</name>"  | indent 4}}
{{ printf "<value>thrift://%s:9083</value>" $service.metadata.name | indent 4}}
{{ printf "</property>"}}
{{- end }}
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
  name: {{ include "library-chart.configMapNameHive" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
data:
  hive-site.xml: |
    {{- include "hiveMetastore.configmap" . | nindent 4 }}
{{- end }}
{{- end }}

{{/*
ConfigMap for Hive Metastore
*/}}
{{- define "library-chart.coreSite" -}}
{{ printf "<?xml version=\"1.0\"?>" }}
{{ printf "<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>" }} 
{{ printf "<configuration>"}}     
{{ printf "<property>"}}
{{ printf "<name>fs.s3a.connection.ssl.enabled</name>" | indent 4}}
{{ printf "<value>true</value>" | indent 4}}
{{ printf "</property>"}}
{{ printf "<property>"}}
{{ printf "<name>fs.s3a.endpoint</name>" | indent 4}}
{{ printf "<value>{{ .Values.s3.endpoint }}</value>" | indent 4}}
{{ printf "</property>"}}
{{ printf "<property>"}}
{{ printf "<name>fs.s3a.path.style.access</name>" | indent 4}}
{{ printf "<value>true</value>" | indent 4}}
{{ printf "</property>"}}
{{ printf "<property>"}}
{{ printf "<name>fs.s3a.aws.credentials.provider</name>" | indent 4}}
{{ printf "<value>org.apache.hadoop.fs.s3a.TemporaryAWSCredentialsProvider</value>" | indent 4}}
{{ printf "</property>"}}
{{ printf "<property>"}}
{{ printf "<name>fs.s3a.access.key</name>" | indent 4}}
{{ printf "<value>{{ .Values.s3.accessKeyId }}</value>" | indent 4}}
{{ printf "</property>"}}
{{ printf "<property>"}}
{{ printf "<name>fs.s3a.secret.key</name>" | indent 4}}
{{ printf "<value>{{ .Values.s3.secretAccessKey }}</value>" | indent 4}}
{{ printf "</property>"}}
{{ printf "<property>"}}
{{ printf "<name>fs.s3a.session.token</name>" | indent 4}}
{{ printf "<value>{{ .Values.s3.sessionToken }}</value>" | indent 4}}
{{ printf "</property>"}}
{{ printf "</configuration>"}}
{{- end }}

{{/*
Create the name of the config map Hive to use
*/}}
{{- define "library-chart.configMapNameCoreSite" -}}
{{- if .Values.s3.enabled -}}
{{- $name:= (printf "%s-configmapcoresite" (include "library-chart.fullname" .) )  }}
{{- default $name .Values.coresite.configMapName }}
{{- else }}
{{- default "default" .Values.coresite.configMapName }}
{{- end }}
{{- end }}

{{/*
Template to generate a ConfigMap for Hive
*/}}
{{- define "library-chart.configMapCoreSite" -}}
{{- if .Values.s3.enabled -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "library-chart.configMapNameCoreSite" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
data:
  core-site.xml: |
    {{- include "library-chart.coreSite" . | nindent 4 }}
{{- end }}
{{- end }}

{{/*
Create the name of the config map MLFlow to use
*/}}
{{- define "library-chart.configMapNameMLFlow" -}}
{{- $name:= (printf "%s-configmapmlflow" (include "library-chart.fullname" .) )  }}
{{- default $name .Values.mlflow.configMapName }}
{{- end }}

{{/*
ConfigMap for Hive Metastore
*/}}
{{- define "library-chart.configMapMLFlow" -}}
{{- if .Values.discovery.mlflow -}}    
{{- $context := . }}
{{ range $index, $service := (lookup "v1" "Service" .Release.Namespace "").items }}
{{- if (index $service "metadata" "labels") }}
{{- if (index $service "metadata" "labels" "helm.sh/chart") }}
{{- if hasPrefix "mlflow" (index $service "metadata" "labels" "helm.sh/chart") }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "library-chart.configMapNameMLFlow" $context }}
  labels:
    {{- include "library-chart.labels" $context | nindent 4 }}
data:
  MLFLOW_TRACKING_URI: {{ print "http://" $service.metadata.name }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}




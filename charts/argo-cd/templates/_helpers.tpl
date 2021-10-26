{{/*
Create argocd server name and version as used by the chart label.
*/}}
{{- define "argo.server.fullname" -}}
{{- printf "%s-%s" (include "library-chart.fullname" .) (index .Values "argo-cd" "server" "name") | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create controller name and version as used by the chart label.
*/}}
{{- define "argo.controller.fullname" -}}
{{- printf "%s-%s" (include "library-chart.fullname" .) (index .Values "argo-cd" "controller" "name") | trunc 63 | trimSuffix "-" -}}
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

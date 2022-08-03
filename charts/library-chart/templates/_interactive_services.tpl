{{/* vim: set filetype=mustache: */}}

{{/* Template to generate an Ingress for the Spark UI */}}
{{- define "library-chart.ingressSpark" -}}
{{- if .Values.ingress.enabled -}}
{{- if .Values.spark.sparkui -}}
{{- $fullName := include "library-chart.fullname" . -}}
{{- $svcPort := .Values.networking.sparkui.port -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $fullName }}-sparkui
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
  annotations:
    {{- include "library-chart.ingress.annotations" . | nindent 4 }}
spec:
{{- if .Values.ingress.tls }}
  tls:
    - hosts:
        - {{ .Values.ingress.sparkHostname | quote }}
{{- end }}
  rules:
    - host: {{ .Values.ingress.sparkHostname | quote }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ $fullName }}
                port: 
                  number: {{ $svcPort }}
{{- end }}
{{- end }}
{{- end }}

{{/* Template to generate a custom Ingress */}}
{{- define "library-chart.ingressUser" -}}
{{- if .Values.ingress.enabled -}}
{{ if .Values.networking.user.enabled }}
{{- $fullName := include "library-chart.fullname" . -}}
{{- $svcPort := .Values.networking.user.port -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $fullName }}-user
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
  annotations:
    {{- include "library-chart.ingress.annotations" . | nindent 4 }}
spec:
{{- if .Values.ingress.tls }}
  tls:
    - hosts:
        - {{ .Values.ingress.userHostname | quote }}
{{- end }}
  rules:
    - host: {{ .Values.ingress.userHostname | quote }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ $fullName }}
                port: 
                  number: {{ $svcPort }}
{{- end }}
{{- end }}
{{- end }}

{{/* Template to generate a standard Ingress */}}
{{- define "library-chart.ingress" -}}
{{- if .Values.ingress.enabled -}}
{{- $fullName := include "library-chart.fullname" . -}}
{{- $svcPort := .Values.networking.service.port -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $fullName }}-ui
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
  annotations:
    {{- include "library-chart.ingress.annotations" . | nindent 4 }}
spec:
{{- if .Values.ingress.tls }}
  tls:
    - hosts:
        - {{ .Values.ingress.hostname | quote }}
{{- end }}
  rules:
    - host: {{ .Values.ingress.hostname | quote }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ $fullName }}
                port: 
                  number: {{ $svcPort }}
{{- end }}
{{- end }}

{{/* Template to generate an Ingress for a NetworkPolicy */}}
{{- define "library-chart.networkPolicyIngress" -}}
{{- if .Values.security.networkPolicy.enabled -}}
{{- if .Values.ingress.enabled -}}
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: {{ include "library-chart.fullname" . }}-2
spec:
  podSelector:
    matchLabels:
      {{- include "library-chart.selectorLabels" . | nindent 6 }}
  ingress:
  - from:
    {{- toYaml .Values.security.networkPolicy.from | nindent 4 }}
  policyTypes:
  - Ingress
{{- end }}
{{- end }} 
{{- end }}

{{/* Template to generate a NetworkPolicy */}}
{{- define "library-chart.networkPolicy" -}}
{{- if .Values.security.networkPolicy.enabled -}}
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: {{ include "library-chart.fullname" . }}
spec:
  podSelector:
    matchLabels:
      {{- include "library-chart.selectorLabels" . | nindent 6 }}
  ingress:
  - from:
    - podSelector: {}
  policyTypes:
  - Ingress
{{- end }} 
{{- end }}

{{/* Template to generate a PVC */}}
{{- define "library-chart.persistentVolumeClaim" -}}
{{- if and .Values.persistence.enabled (not .Values.persistence.existingClaim) }}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ include "library-chart.fullname" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
spec:
  accessModes:
    - {{ .Values.persistence.accessMode | quote }}
  resources:
    requests:
      storage: {{ .Values.persistence.size | quote }}
{{- if .Values.persistence.storageClass }}
{{- if (eq "-" .Values.persistence.storageClass) }}
  storageClassName: ""
{{- else }}
  storageClassName: "{{ .Values.persistence.storageClass }}"
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/* Template to generate a RoleBinding */}}
{{- define "library-chart.roleBinding" -}}
{{- if .Values.serviceAccount.create -}}
{{- if .Values.kubernetes.enabled -}}
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ include "library-chart.serviceAccountName" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: {{ .Values.kubernetes.role}}
subjects:
- kind: ServiceAccount
  name: {{ include "library-chart.serviceAccountName" . }}
  namespace: {{ .Release.Namespace }}
{{- end }}
{{- end }}
{{- end }}

{{/* Template to generate a Service */}}
{{- define "library-chart.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "library-chart.fullname" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
spec:
  type: {{ .Values.networking.type }}
  {{- if .Values.networking.clusterIP }}
  clusterIP: {{ .Values.networking.clusterIP }}
  {{- end }}
  ports:
    - port: {{ .Values.networking.service.port }}
      targetPort: http
      protocol: TCP
      name: http
    {{ if .Values.networking.user.enabled }}
    - port: {{ .Values.networking.user.port }}
      targetPort: {{ .Values.networking.user.port }}
      protocol: TCP
      name: user
    {{- end }}
  selector:
    {{- include "library-chart.selectorLabels" . | nindent 4 }}
{{- end }}

{{/* Template to generate a ServiceAccount */}}
{{- define "library-chart.serviceAccount" -}}
{{- if .Values.serviceAccount.create -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "library-chart.serviceAccountName" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}

{{/* Template to generate a Pod which tests connection to the service */}}
{{- define "library-chart.testConnection" -}}
apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "library-chart.fullname" . }}-test-connection"
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": test-success
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['{{ include "library-chart.fullname" . }}:{{ .Values.networking.service.port }}']
  restartPolicy: Never
{{- end }}

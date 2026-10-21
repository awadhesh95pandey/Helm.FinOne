{{/*
Container image reference (digest preferred over tag)
*/}}
{{- define "react-erp-ui.image" -}}
{{- if .Values.image.digest -}}
{{- printf "%s@%s" .Values.image.repository .Values.image.digest -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end }}

{{/*
GHCR docker config JSON for imagePullSecret
*/}}
{{- define "react-erp-ui.ghcrDockerConfigJson" -}}
{{- $auth := printf "%s:%s" .Values.ghcrPullSecret.username .Values.ghcrPullSecret.password | b64enc -}}
{{- $cfg := dict "auths" (dict .Values.ghcrPullSecret.registry (dict "username" .Values.ghcrPullSecret.username "password" .Values.ghcrPullSecret.password "auth" $auth)) -}}
{{- $cfg | toJson | b64enc -}}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "react-erp-ui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "react-erp-ui.fullname" -}}
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
{{- define "react-erp-ui.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "react-erp-ui.labels" -}}
helm.sh/chart: {{ include "react-erp-ui.chart" . }}
{{ include "react-erp-ui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "react-erp-ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "react-erp-ui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "react-erp-ui.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "react-erp-ui.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

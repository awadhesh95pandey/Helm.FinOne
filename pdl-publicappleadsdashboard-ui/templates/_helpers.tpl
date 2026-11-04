{{- define "pdl-publicappleadsdashboard-ui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "pdl-publicappleadsdashboard-ui.fullname" -}}
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

{{- define "pdl-publicappleadsdashboard-ui.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "pdl-publicappleadsdashboard-ui.labels" -}}
helm.sh/chart: {{ include "pdl-publicappleadsdashboard-ui.chart" . }}
{{ include "pdl-publicappleadsdashboard-ui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "pdl-publicappleadsdashboard-ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pdl-publicappleadsdashboard-ui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "pdl-publicappleadsdashboard-ui.image" -}}
{{- if .Values.image.digest -}}
{{- $digest := .Values.image.digest -}}
{{- if not (hasPrefix "sha256:" $digest) -}}
{{- $digest = printf "sha256:%s" $digest -}}
{{- end -}}
{{- printf "%s@%s" .Values.image.repository $digest -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end -}}

{{- define "pdl-publicappleadsdashboard-ui.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pdl-publicappleadsdashboard-ui.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

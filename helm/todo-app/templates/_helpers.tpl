{{/* define application name */}}
{{- define "todo-app.fullname" -}}
{{- /* Helm Official trunc */ -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
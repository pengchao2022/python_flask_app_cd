{{/* 定义应用的全称 */}}
{{- define "todo-app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | truncate 63 | trimSuffix "-" -}}
{{- end -}}
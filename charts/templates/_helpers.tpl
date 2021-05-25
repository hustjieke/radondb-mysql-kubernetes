{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}} /*helm 的函数, 这里有个问题,我们Values对应的values.yaml,而不是大写的*/
{{- end -}}

{{/*
Create a default fully qualified app name.
The format of host is "fullname"-0."fullname"."namespace" (podname.servicename.namespace), 
and the MySQL limits the total length of master_host to 60 byte, 
so the length of "fullname" must be limited to '(60-4-len(namespace))/2'.
*/}}
{{- define "fullname" -}}
{{- $length := div (sub 56 (len .Release.Namespace )) 2 | int }}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc $length | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc $length | trimSuffix "-" -}}
{{- else -}}
// gry 这里就是release-name由来: demo-radondb-mysql,然后pod生成后加后缀:0,1,2
{{- printf "%s-%s" .Release.Name $name | trunc $length | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "radondb-mysql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

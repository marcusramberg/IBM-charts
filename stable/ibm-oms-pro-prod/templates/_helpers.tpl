# Licensed Materials - Property of IBM
# IBM Order Management Software (5725-D10)
# (C) Copyright IBM Corp. 2018, 2020 All Rights Reserved.
# US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "om-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "om-chart.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "om-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create productID, product name and version for metering purpose.
*/}}
{{- define "om-chart.metering.prodname" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodname=.*" . -}}
{{- substr 9 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "om-chart.metering.prodid" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodid=.*" . -}}
{{- substr 7 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "om-chart.metering.prodversion" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodversion=.*" . -}}
{{- substr 12 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "om-chart.metering.prodmetric" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodmetric=.*" . -}}
{{- substr 11 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "om-chart.metering.prodchargedcontainers" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodchargedcontainers=.*" . -}}
{{- substr 22 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "om-chart.metering.prodcloudpakratio" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^prodcloudpakratio=.*" . -}}
{{- substr 18 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "om-chart.metering.cloudpakname" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^cloudpakname=.*" . -}}
{{- substr 13 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "om-chart.metering.cloudpakid" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^cloudpakid=.*" . -}}
{{- substr 11 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- define "om-chart.metering.cloudpakversion" -}}
{{ range ( .Files.Lines "version.info" ) -}}
{{- if regexMatch "^cloudpakversion=.*" . -}}
{{- substr 16 (len .) . -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
name for the default ingress secret
*/}}
{{- define "om-chart.auto-ingress-secret" -}}
{{- include "om-chart.fullname" . | printf "%s-auto-ingress-secret" -}}
{{- end -}}



{{/*
create ingress paths based on context root
*/}}
{{- define "om-chart.ingress.paths.notes" -}}
{{- $varRoot := index . 0 }}
{{- $baseURL := index . 1 }}
{{- $contextList := index . 2 }}
{{- range $contextList }}
{{- $ctxRoot := .}}
{{- if $ctxRoot }}
{{- if contains "smcfsdocs" $ctxRoot.path }}
{{ printf "%s : %s/%s" $ctxRoot.dockey $baseURL $ctxRoot.path }}
{{- else }}
{{ printf "%s : %s/%s" $ctxRoot.path $baseURL $ctxRoot.path }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}


{{/*
create ingress paths based on context root
*/}}
{{- define "om-chart.routes.paths.notes" -}}
{{- $varRoot := index . 0 }}
{{- $protocol := index . 1 }}
{{- $host := index . 2 }}
{{- $contextList := index . 3 }}
{{- range $contextList }}
{{- $ctxRoot := .}}
{{- if $ctxRoot }}
{{- if contains "smcfsdocs" $ctxRoot.path }}
{{ printf "%s : %s://%s.%s.%s/%s" $ctxRoot.dockey $protocol $ctxRoot.routePrefix $varRoot.Release.Name $host $ctxRoot.path }}
{{- else }}
{{ printf "%s : %s://%s.%s.%s/%s" $ctxRoot.routePrefix $protocol $ctxRoot.routePrefix $varRoot.Release.Name $host $ctxRoot.path }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}


{{/*
db schema defaulting logic
*/}}
{{- define "om-chart.dbschema" }}
{{- $varRoot := index . 0 }}
{{- $defaultVal := index . 1 }}
{{- if $varRoot.Values.global.database.schema }}
jdbcService.{{ $varRoot.Values.global.database.dbvendor | lower }}Pool.schema={{ $varRoot.Values.global.database.schema }}
si_config.DB_SCHEMA_OWNER={{ $varRoot.Values.global.database.schema }}
{{- else }}
jdbcService.{{ $varRoot.Values.global.database.dbvendor | lower }}Pool.schema={{ $defaultVal }}
si_config.DB_SCHEMA_OWNER={{ $defaultVal }}
{{- end }}
{{- end }}

{{/*
name for the default monitoring dashboard
*/}}
{{- define "om-chart.monitoring-dashboard" -}}
{{- include "om-chart.fullname" . | printf "%s-monitoring-dashboard" -}}
{{- end -}}


{{/*
Name for appserver deployments facilitating multiple app images.
*/}}
{{- define "om-chart.application" -}}
{{- $varRoot := index . 0 }}
{{- $name := printf "%s" ($varRoot.name | replace "_" "-") -}}
{{- if hasKey $varRoot "purpose" }}
{{- if eq $varRoot.purpose "xapirest" -}}
{{- $name = "xapirest" -}}
{{- end -}}
{{- end -}}
{{- $name -}}
{{- end -}}

{{/*
Unique hostname for routes
*/}}
{{- define "om-chart.route-host" -}}
{{- $ctxRoot := index . 0 }}
{{- $varRoot := index . 1 }}
{{- printf "%s.%s.%s" ($ctxRoot.routePrefix | lower) $varRoot.Release.Name $varRoot.Values.appserver.ingress.host -}}
{{- end -}}

{{/*
Return "true" if core datasetup is required
*/}}
{{- define "om-chart.require-core-datasetup" -}}
{{- if and (.Values.datasetup.loadFactoryData) (eq .Values.datasetup.loadFactoryData "install") }}
{{- printf "true" -}}
{{- else }}
{{- printf "false" -}}
{{- end }}
{{- end -}}

{{/*
Return "true" if FP datasetup is required
*/}}
{{- define "om-chart.require-fp-datasetup" -}}
{{- if and (.Values.datasetup.fixPack.loadFPFactoryData) (eq .Values.datasetup.fixPack.loadFPFactoryData "install") }}
{{- printf "true" -}}
{{- else }}
{{- printf "false" -}}
{{- end }}
{{- end -}}

{{/*
Return "true" if either core or FP datasetup is required
*/}}
{{- define "om-chart.require-datasetup" -}}
{{- if or (eq (include "om-chart.require-core-datasetup" .) "true") (eq (include "om-chart.require-fp-datasetup" .) "true") }}
{{- printf "true" -}}
{{- else }}
{{- printf "false" -}}
{{- end }}
{{- end -}}
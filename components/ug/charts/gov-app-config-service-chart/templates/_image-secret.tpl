{{- define "image-secret" }}
{{- if .Values.imagePullSecrets }}
imagePullSecrets:
  - name: {{ .Values.imagePullSecrets.stage }}
  - name: {{ .Values.imagePullSecrets.release }}
  - name: {{ .Values.imagePullSecrets.drcreds }}
{{- end }}
{{- end }}

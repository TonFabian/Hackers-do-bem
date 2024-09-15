# Defina variáveis de ambiente
PASSWORD=${PASSWORD:-default_password}
USERNAME=${USERNAME:-default_user}
ZAP_REPORT=${ZAP_REPORT:-zap_report}
ZAP_ALERT_REPORT=${ZAP_ALERT_REPORT:-zap_alert_report}

# Execute o ZAP scan
echo "Iniciando o OWASP ZAP Scan..."
zap-cli quick-scan -r ${ZAP_REPORT} -a ${ZAP_ALERT_REPORT}

# Gera um relatório de alerta
zap-cli alerts -r ${ZAP_ALERT_REPORT}

echo "Scan concluído."


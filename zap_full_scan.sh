#!/bin/bash

# Defina variáveis de ambiente
TARGET_URL=${TARGET_URL:-http://example.com}
ZAP_API_KEY=${ZAP_API_KEY:-your_api_key}
ZAP_HOST=${ZAP_HOST:-localhost}
ZAP_PORT=${ZAP_PORT:-8080}
SCAN_REPORT=${SCAN_REPORT:-zap_scan_report.html}
ALERT_REPORT=${ALERT_REPORT:-quick_scan_alert_report.md}

# Cria um arquivo de teste para verificar o diretório
echo "Criando arquivo de teste..."
TEST_FILE="/zap/wrk/test_file_created.txt"
echo "Arquivo de teste criado" > $TEST_FILE

# Verifique se o arquivo de teste foi criado
if [ -f "$TEST_FILE" ]; then
    echo "Arquivo de teste criado com sucesso."
else
    echo "Falha ao criar o arquivo de teste. Verifique o diretório."
    exit 1
fi

# Inicie o OWASP ZAP em modo daemon
echo "Iniciando o OWASP ZAP..."
/zap/zap.sh -daemon -host 0.0.0.0

# Aguardar o OWASP ZAP iniciar
echo "Aguardando o OWASP ZAP iniciar..."
sleep 30  # Ajuste se necessário

# Verifique se o OWASP ZAP está realmente em execução
if ! curl -s "http://${ZAP_HOST}:${ZAP_PORT}/json/core/view/version/" > /dev/null; then
    echo "OWASP ZAP não está acessível. Verifique os logs para mais detalhes."
    exit 1
fi

# Inicie o scan ativo
echo "Iniciando o OWASP ZAP Scan..."
SCAN_URL= "http://${ZAP_HOST}:${ZAP_PORT}/json/ascan/action/scan/?url=${TARGET_URL}&recurse=true&insect=true&apikey=${ZAP_API_KEY}"
echo "Executando comando: curl -s \${SCAN_URL}"
curl -s "$SCAN_URL"
if [ $? -ne 0 ]; then
    echo "Falha ao iniciar o scan. Verifique a URL e a chave da API."
    exit 1 
fi

# Aguardar o scan terminar (ajuste o tempo de espera conforme necessário)
echo "Aguardando o scan terminar..."
sleep 600  # Aguardar 10 minutos para o scan (ajuste conforme necessário)

# Gere o relatório de alertas
echo "Gerando relatório de alertas..."
REPORT_URL="http://${ZAP_HOST}:${ZAP_PORT}/JSON/core/action/htmlreport/?apikey=${ZAP_API_KEY}"
echo "Executando comando: curl -s \${REPORT_URL}\ -o ${SCAN_REPORT}"
curl -s "$REPORT_URL" -o ${SCAN_REPORT}
if [ $? -ne 0 ]; then
    echo "Falha ao gerar o relatório. Verifique a URL e a chave da API."
    exit 1
fi

# Verifique se o arquivo de relatório de alertas foi criado
echo "Verificando se o relatório de alertas foi criado..."
if [ -f "/zap/wrk/${ALERT_REPORT}" ]; then
    echo "Relatório de alertas encontrado: ${ALERT_REPORT}"
else
    echo "Relatório de alertas não encontrado: ${ALERT_REPORT}"
    exit 1
fi

# Listar arquivos no diretório wrk
echo "Listando arquivos no diretório /zap/wrk/"
ls -l /zap/wrk/

echo "Scan concluído. Relatório salvo como ${SCAN_REPORT}."


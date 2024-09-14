#!/bin/bash

# Substituição das variáveis no arquivo de configuração
sed -i "s/PASSWORD/$PASSWORD/g" /zap/zap_config.conf
sed -i "s/USERNAME/$USERNAME/g" /zap/zap_config.conf
sed -i "s/ZAP_REPORT/$ZAP_REPORT/g" /zap/zap_config.conf
sed -i "s/CI_PROJECT_DIR/$CI_PROJECT_DIR/g" /zap/zap_config.conf
sed -i "s/ZAP_ALERT_REPORT/$ZAP_ALERT_REPORT/g" /zap/zap_config.conf

# Executar o ZAP no modo de análise completa
/zap/zap.sh -cmd -quickurl http://my-app:5000 -quickout /zap/${ZAP_REPORT}.html

# Verificação dos resultados
returnCode=0
if grep -q "Instances" /zap/${ZAP_ALERT_REPORT}.md; then
  head -n 20 /zap/${ZAP_ALERT_REPORT}.md
  echo "DAST RESULT: There are some vulnerabilities that ZAP has found (those visible here may not be the only ones). See the detailed report for more information."
  returnCode=1
fi

exit $returnCode


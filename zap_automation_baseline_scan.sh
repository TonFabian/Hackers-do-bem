#!/bin/bash

# Verificação de variáveis
if [ -z "$PASSWORD" ] || [ -z "$USERNAME" ] || [ -z "$ZAP_REPORT" ] || [ -z "$CI_PROJECT_DIR" ] || [ -z "$ZAP_ALERT_REPORT" ]; then
  echo "One or more required environment variables are not set."
  exit 1
fi

# Substituição das variáveis no arquivo de configuração
sed -i "s/PASSWORD/$PASSWORD/g" /home/werton/Task-Manager-using-Flask/ZAP_2.15.0/broken_crystals.yaml
sed -i "s/USERNAME/$USERNAME/g" /home/werton/Task-Manager-using-Flask/ZAP_2.15.0/broken_crystals.yaml
sed -i "s/ZAP_REPORT/$ZAP_REPORT/g" /home/werton/Task-Manager-using-Flask/ZAP_2.15.0/broken_crystals.yaml
sed -i "s/CI_PROJECT_DIR/\/zap\/wrk/g" /home/werton/Task-Manager-using-Flask/ZAP_2.15.0/broken_crystals.yaml
sed -i "s/ZAP_ALERT_REPORT/$ZAP_ALERT_REPORT/g" /home/werton/Task-Manager-using-Flask/ZAP_2.15.0/broken_crystals.yaml

# Execução do ZAP
docker run -it --rm --name zap-container -v $CI_PROJECT_DIR:/zap/wrk -p 8080:8080 zaproxy/zap-stable:2.15.0 /zap/zap.sh -cmd -autorun /zap/wrk/broken_crystals.yaml

# Verificação de resultados
returnCode=0
if grep -q "Instances" /zap/wrk/$ZAP_ALERT_REPORT.md; then
  head -n 20 /zap/wrk/$ZAP_ALERT_REPORT.md
  echo "DAST RESULT: There are some vulnerabilities that ZAP has found (those visible here may not be the only ones). See the detailed report for more information."
  returnCode=1
fi

exit $returnCode


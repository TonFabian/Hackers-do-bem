#!/bin/bash

# Substituição das variáveis no arquivo de configuração
sed -i "s/PASSWORD/$PASSWORD/g" zap/broken_crystals.yaml
sed -i "s/USERNAME/$USERNAME/g" zap/broken_crystals.yaml
sed -i "s/ZAP_REPORT/$ZAP_REPORT/g" zap/broken_crystals.yaml

# Escapamento de caracteres no caminho do projeto
ESCAPED_CI_PROJECT_DIR=$(sed -e 's/[&\\/]/\\&/g; s/$/\\/' -e '$s/\\$//' <<<"$CI_PROJECT_DIR")
sed -i "s/CI_PROJECT_DIR/$ESCAPED_CI_PROJECT_DIR/g" zap/broken_crystals.yaml

sed -i "s/ZAP_ALERT_REPORT/$ZAP_ALERT_REPORT/g" zap/broken_crystals.yaml

# Execução do ZAP
docker run -it --rm --name zap-container -v $CI_PROJECT_DIR:/zap/wrk -p 8080:8080 zaproxy/zap-stable:2.15.0 /zap/zap.sh -cmd -autorun /zap/wrk/zap/broken_crystals.yaml

# Verificação de resultados
returnCode=0
if grep -q "Instances" $ZAP_ALERT_REPORT.md; then
  head -n 20 $ZAP_ALERT_REPORT.md
  echo "DAST RESULT: There are some vulnerabilities that ZAP has found (those visible here may not be the only ones). See the detailed report for more information."
  returnCode=1
fi

exit $returnCode

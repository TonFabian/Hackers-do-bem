# Use a imagem base do OWASP ZAP
FROM zaproxy/zap-stable:2.15.0

# Defina o diretório de trabalho
WORKDIR /zap

# Exponha a porta padrão utilizada pelo OWASP ZAP
EXPOSE 8080

# Comando padrão para iniciar o OWASP ZAP em modo daemon e escutar em todas as interfaces
ENTRYPOINT ["/zap/zap.sh", "-daemon", "-host", "0.0.0.0"]


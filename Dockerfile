# Use a imagem base do Ubuntu 20.04
FROM ubuntu:20.04

# Instale dependências necessárias
RUN apt-get update && apt-get install -y \
    openjdk-11-jre \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Baixe e extraia o OWASP ZAP
RUN wget -q https://github.com/zaproxy/zaproxy/releases/download/v2.15.0/ZAP_2.15.0_Linux.tar.gz \
    && tar -xzf ZAP_2.15.0_Linux.tar.gz \
    && rm ZAP_2.15.0_Linux.tar.gz \
    && mv ZAP_2.15.0 /zap

# Defina o diretório de trabalho
WORKDIR /zap

# Exponha a porta padrão utilizada pelo OWASP ZAP
EXPOSE 8080

# Comando padrão para iniciar o OWASP ZAP
ENTRYPOINT ["./zap.sh"]

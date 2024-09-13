FROM ubuntu:20.04

# Instale dependências
RUN apt-get update && apt-get install -y \
    openjdk-11-jre \
    wget \
    unzip

# Baixe e extraia o OWASP ZAP
RUN wget -q https://github.com/zaproxy/zaproxy/releases/download/v2.15.0/ZAP_2.15.0_Linux.tar.gz \
    && tar -xzf ZAP_2.15.0_Linux.tar.gz \
    && rm ZAP_2.15.0_Linux.tar.gz

# Defina o diretório de trabalho
WORKDIR /ZAP_2.15.0

# Comando padrão
ENTRYPOINT ["./zap.sh"]

[[runners]]
  name = "docker-runner"
  url = "https://gitlab.com/"
  token = "glrt-njLa4MWpNxp3Um7EQGWZ"
  executor = "docker"
  [runners.docker]
    tls_verify = false
    image = "ruby:3.1"
    privileged = true

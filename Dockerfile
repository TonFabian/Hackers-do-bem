# Use a imagem base do OWASP ZAP
FROM zaproxy/zap-stable:2.15.0

# Defina o diretório de trabalho
WORKDIR /zap

# Cria um diretório dentro do container
RUN mkdir -p /zap/wrk && chmod -R 777 /zap/wrk

# Copia arquivos da máquina local para o container
COPY ./broken_crystals.yaml /zap/wrk/broken_crystals.yaml
COPY ./zap_full_scan.sh /zap/zap_full_scan.sh

# Cria um arquivo dentro do container
RUN echo "conteúdo do arquivo" > /zap/wrk/arquivo_criado.txt

# Exponha a porta padrão utilizada pelo OWASP ZAP
EXPOSE 8081

# Comando padrão para iniciar o OWASP ZAP em modo daemon e escutar em todas as interfaces
ENTRYPOINT ["/zap/zap.sh", "-daemon", "-host", "0.0.0.0", "-port", "8081"]


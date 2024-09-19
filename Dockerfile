# Usando uma imagem base do Python
FROM python:3.9-slim

# Definindo o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copiando os arquivos necessários para o contêiner
COPY . /app

# Instalando as dependências
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Definindo as variáveis de ambiente necessárias
ENV FLASK_APP=todo_project/run.py
ENV FLASK_ENV=development

# Expondo a porta da aplicação
EXPOSE 5000

# Comando para rodar o Flask
CMD ["flask", "run", "--host=0.0.0.0"]


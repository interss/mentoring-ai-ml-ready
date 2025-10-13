# 1. Base image: We use an official Python 3.11 slim image
# PT-BR: 1. Imagem base: Usamos uma imagem oficial do Python 3.11 slim
FROM python:3.11-slim

# 2. Define the working directory inside the container
# PT-BR: 2. Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# 3. Copy the dependency file to the container
# PT-BR: 3. Copia o arquivo de dependências para o contêiner
COPY requirements.txt .

# 4. Install the dependencies
# PT-BR: 4. Instala as dependências
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy all the application code (the 'app' folder) into the container
# PT-BR: 5. Copia todo o código da aplicação (a pasta 'app') para o contêiner
COPY ./app .

# 6. Expose port 8000 so we can connect to the container
# PT-BR: 6. Expõe a porta 8000 para que possamos nos conectar ao contêiner
EXPOSE 8000

# 7. Command to start the application when the container is run
# PT-BR: 7. Comando para iniciar a aplicação quando o contêiner for executado
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
# =================================================================
# STAGE 1: The "Builder" stage
# PT-BR: ESTÁGIO 1: O estágio "Construtor"
# =================================================================
FROM python:3.11 AS builder

# Set the working directory
# PT-BR: Define o diretório de trabalho
WORKDIR /app

# Upgrade pip and install wheel to ensure everything works smoothly
# PT-BR: Atualiza o pip e instala o 'wheel' para garantir que tudo funcione bem
RUN pip install --upgrade pip wheel

# Copy only the requirements file to leverage Docker cache
# PT-BR: Copia apenas o arquivo de requisitos para aproveitar o cache do Docker
COPY requirements.txt .

# Install dependencies as "wheels"
# PT-BR: Instala as dependências como "wheels"
RUN pip wheel --no-cache-dir --wheel-dir /app/wheels -r requirements.txt


# =================================================================
# STAGE 2: The "Final" stage
# PT-BR: ESTÁGIO 2: O estágio "Final"
# =================================================================
FROM python:3.11-slim

# Set the working directory
# PT-BR: Define o diretório de trabalho
WORKDIR /app

# Copy the pre-compiled packages from the "builder" stage
# PT-BR: Copia os pacotes pré-compilados do estágio "builder"
COPY --from=builder /app/wheels /wheels/

# Install the packages from the local wheels
# PT-BR: Instala os pacotes a partir dos wheels locais
RUN pip install --no-cache-dir --no-index --find-links=/wheels /wheels/*

# Copy the application code
# PT-BR: Copia o código da aplicação
COPY ./app .

# Expose the port
# PT-BR: Expõe a porta
EXPOSE 8000

# Command to start the application
# PT-BR: Comando para iniciar a aplicação
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
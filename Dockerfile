# Define a base de imagem. Usamos uma imagem oficial do Python com Alpine Linux
# para manter a imagem final pequena. A versão 3.12 é estável e atende ao
# pré-requisito de "Python 3.10 ou superior" do seu readme.md.
FROM python:3.12-alpine

# Define o diretório de trabalho dentro do contêiner.
WORKDIR /app

# Copia o arquivo de dependências para o contêiner.
# Fazemos isso antes de copiar o resto do código para aproveitar o cache de camadas do Docker.
COPY requirements.txt .

# Instala as dependências do projeto.
# A flag --no-cache-dir reduz o tamanho da imagem final.
RUN pip install --no-cache-dir -r requirements.txt

# Copia todos os arquivos do projeto para o diretório de trabalho no contêiner.
COPY . .

# Expõe a porta 8000, que é a porta padrão que o uvicorn usará.
EXPOSE 8000

# Define o comando para executar a aplicação quando o contêiner iniciar.
# Usamos --host 0.0.0.0 para que a aplicação seja acessível de fora do contêiner.
# A flag --reload não é usada em produção.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

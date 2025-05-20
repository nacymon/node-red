FROM node:20-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates git && \
    rm -rf /var/lib/apt/lists/*

# Instalacja node-red
RUN npm install -g --omit=dev node-red

WORKDIR /usr/src/app

# Jeśli masz plik settings.js – skopiuj go do katalogu /data
COPY settings.js /data/settings.js
COPY . .

ENV PORT=1880
EXPOSE 1880

CMD ["node-red", "--port", "1880"]


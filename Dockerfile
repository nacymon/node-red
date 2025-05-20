FROM node:20-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY . .

RUN npm install --omit=dev

# Domyślny port Node-RED
EXPOSE 1880

CMD ["npx", "node-red"]

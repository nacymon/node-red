FROM node:20-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates git && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g --omit=dev node-red

WORKDIR /usr/src/app

COPY settings.js /data/settings.js
COPY . .

ENV PORT=3000
EXPOSE 3000

CMD ["false"]



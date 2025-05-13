FROM node:20-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY . .

RUN npm install --production

ENV PORT=3000
EXPOSE 3000

CMD ["npm", "start"]

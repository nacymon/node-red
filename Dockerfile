FROM node:20-slim

# Instalacja curl i czyszczenie cache
RUN apt-get update && apt-get install -y curl && apt-get clean

WORKDIR /usr/src/app
COPY . .

RUN npm install --production

ENV PORT=3000
EXPOSE 3000

CMD ["npm", "start"]

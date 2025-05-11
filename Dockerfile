FROM node:20-slim

# Zainstaluj curl, jeżeli potrzebujesz
RUN apt-get update && apt-get install -y curl

WORKDIR /usr/src/app
COPY . .

RUN npm install --production

# Zmieniamy port na 3000
ENV PORT 3000
EXPOSE 3000

# Uruchomienie aplikacji na porcie 3000
CMD ["npm", "start"]

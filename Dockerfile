FROM node:20-slim
WORKDIR /usr/src/app
COPY . .
RUN npm install --production
EXPOSE 1880
CMD ["npm", "start"]

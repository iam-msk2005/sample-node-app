FROM node:18-alpine

RUN apt-get update && \
apt-get install -y --no-install-recommends curl tini && \
rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]
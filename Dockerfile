FROM node:latest

RUN mkdir -p /src/hubot
WORKDIR /src/hubot

COPY . /src/hubot
RUN npm install

EXPOSE 8080

ENTRYPOINT ["bin/hubot", "-a", "slack"]

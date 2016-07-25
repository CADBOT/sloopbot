FROM node:latest

ENV HUBOT_PORT 8080
ENV HUBOT_ADAPTER slack
ENV HUBOT_NAME sloopbot
ENV HUBOT_SLACK_TOKEN xoxb-6635762980-zxbfbJB5Np5r8CysxQqXpD1p
ENV HUBOT_SLACK_TEAM team-name
ENV HUBOT_SLACK_BOTNAME ${HUBOT_NAME}
ENV PORT ${HUBOT_PORT}

RUN mkdir -p /src/hubot
WORKDIR /src/hubot

COPY . /src/hubot
RUN npm install

EXPOSE ${HUBOT_PORT}

ENTRYPOINT ["bin/hubot", "-a", "slack"]

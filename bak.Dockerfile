#FROM node:12-alpine3.12
FROM node:12-alpine

ENV NODE_ENV production

#RUN mkdir /home/node/app/ && chown -R node:node /home/node/app
RUN mkdir /quickchart && chown -R node:node /quickchart

#WORKDIR /home/node/app
WORKDIR /quickchart

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

#RUN apk add --upgrade apk-tools
RUN apk add --no-cache libc6-compat
#RUN apk add --no-cache --virtual .build-deps yarn git build-base g++ python3
RUN apk add --no-cache --virtual .build-deps yarn git build-base g++ python
RUN apk add --no-cache --virtual .npm-deps cairo-dev pango-dev libjpeg-turbo-dev
RUN apk add --no-cache --virtual .fonts libmount ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family font-noto font-noto-emoji fontconfig
RUN apk add wqy-zenhei --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing --allow-untrusted
#RUN apk add libimagequant-dev --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main
#RUN apk add vips-dev --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add --no-cache --virtual .runtime-deps graphviz

#COPY --chown=node:node package*.json ./
COPY package*.json .
COPY yarn.lock .
COPY ./node_modules ./node_modules

USER node

#RUN npm install --loglevel verbose && npm cache clean --force --loglevel=error
RUN yarn install --production

#COPY --chown=node:node index.js .
#COPY --chown=node:node lib ./lib/

#RUN apk update
#RUN rm -rf /var/cache/apk/* && \
#    rm -rf /tmp/*
#RUN apk del .build-deps

COPY *.js ./
COPY lib ./lib/
COPY LICENSE ./

EXPOSE 3400

ENTRYPOINT ["node", "--max-http-header-size=65536", "index.js"]
#CMD ["node", "--max-http-header-size=65536", "index.js"]
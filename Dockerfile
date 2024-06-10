FROM node:18-alpine3.17

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_ENV production
ENV DISABLE_TELEMETRY true

#RUN mkdir /quickchart

WORKDIR /quickchart

RUN apk add --upgrade apk-tools
RUN apk add --no-cache libc6-compat
RUN apk add --no-cache --virtual .build-deps yarn git build-base g++ python3
#RUN apk add --no-cache --virtual .build-deps yarn git build-base g++ python
RUN apk add --no-cache --virtual .npm-deps cairo-dev pango-dev libjpeg-turbo-dev librsvg-dev
#RUN apk add --no-cache --virtual .fonts libmount ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family font-noto font-noto-emoji fontconfig
RUN apk add --no-cache --virtual .fonts libmount ttf-dejavu ttf-droid ttf-freefont ttf-liberation font-noto font-noto-emoji fontconfig
RUN apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/community font-wqy-zenhei
RUN apk add --no-cache libimagequant-dev
RUN apk add --no-cache vips-dev
#RUN apk add libimagequant-dev --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main
#RUN apk add tiff --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main
RUN apk add --no-cache --virtual .runtime-deps graphviz

COPY package*.json .
COPY yarn.lock .

#--verbose
RUN yarn install --production
RUN yarn add chartjs-plugin-colorschemes --production

RUN apk update
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
RUN apk del .build-deps

COPY *.js ./
COPY lib ./lib/
COPY LICENSE ./

EXPOSE 3400

ENTRYPOINT ["node", "--max-http-header-size=65536", "index.js"]

ARG BASE_IMAGE=alpine:3.11


FROM ${BASE_IMAGE} as bin

RUN set -xe \
 && apk add --no-cache \
      curl \
 && curl -sSL -o /usr/local/bin/composer https://getcomposer.org/composer-stable.phar \
 && curl -sSL -o /usr/local/bin/caddy https://github.com/caddyserver/caddy/releases/download/v2.0.0-beta.13/caddy2_beta13_linux_amd64 \
 && curl -sSL -o /usr/local/bin/symfony https://github.com/symfony/cli/releases/download/v4.12.8/symfony_linux_amd64 \
 && chmod +x /usr/local/bin/*

FROM ${BASE_IMAGE} as web

RUN set -xe \
 && echo "http://dl-cdn.alpinelinux.org/alpine/v3.10/main" > /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/v3.10/community" >> /etc/apk/repositories \
 && addgroup basegroup \
 && adduser -D -h /home -s /bin/bash -G basegroup baseuser

RUN set -xe \
 && apk upgrade --no-cache --quiet --available \
 && apk add --no-cache \
      bash \
      php7 \
      php7-apcu \
      php7-bcmath \
      php7-ctype \
      php7-curl \
      php7-dom \
      php7-fpm \
      php7-iconv \
      php7-intl \
      php7-json \
      php7-mbstring \
      php7-opcache \
      php7-openssl \
      php7-pdo \
      php7-pdo_pgsql \
      php7-pcntl \
      php7-posix \
      php7-session \
      php7-simplexml \
      php7-sockets \
      php7-tokenizer \
      php7-xml \
      php7-xmlwriter \
      php7-zip \
      pcre \
      supervisor

COPY --from=bin \
 /usr/local/bin/caddy \
 /usr/local/bin/

COPY fs/ /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisor/website.conf"]


FROM web

RUN set -xe \
 && apk add --no-cache \
      curl \
      g++ \
      git \
      make \
      nodejs \
      npm \
      php7-phar \
      su-exec \
      yarn

COPY --from=bin \
  /usr/local/bin/composer \
  /usr/local/bin/symfony \
  /usr/local/bin/

ENV PATH $PATH:vendor/bin/
ENV TERM xterm

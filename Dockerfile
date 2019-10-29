FROM webdevops/php-nginx:latest
ENV WEB_DOCUMENT_ROOT /app/public
WORKDIR /app
COPY . .
RUN mkdir templates_c && chown www-data:www-data templates_c && chmod 777 templates_c


# SGCI-API — baseado no Dockerfile padrão do projeto (PHP 8.4 + Apache + Node 24)
FROM thecodingmachine/php:8.4-v5-apache-node24

# Document root do Laravel e extensões necessárias (MySQL/Aiven, testes, imagens)
ENV APACHE_DOCUMENT_ROOT=public/ \
    PHP_EXTENSIONS="pdo_mysql pdo_sqlite gd intl" \
    PHP_INI_MEMORY_LIMIT=512M

WORKDIR /var/www/html

# Camada de dependências (cache de build)
COPY --chown=docker:docker composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --no-interaction --prefer-dist

COPY --chown=docker:docker . .
RUN composer dump-autoload --optimize --no-dev --no-interaction \
 && mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views storage/logs bootstrap/cache \
 && chmod -R ug+rwX storage bootstrap/cache

EXPOSE 80
# CMD/entrypoint herdados da imagem (apache). Em produção (Render), migrations via:
#   STARTUP_COMMAND_1="php artisan migrate --force"

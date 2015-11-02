FROM php:5.6-fpm

# Install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    imagemagick \
    libmagickwand-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev && \
    apt-get clean && apt-get autoremove -y

RUN docker-php-ext-install exif iconv mbstring mcrypt mysql mysqli pdo_mysql opcache pdo zip
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
      docker-php-ext-install gd
RUN echo | pecl install imagick-beta


COPY src/conf/php/php.ini /usr/local/etc/php/php.ini
COPY src/commands/start /usr/local/bin/start
RUN chmod 755 /usr/local/bin/start
CMD ["/usr/local/bin/start"]

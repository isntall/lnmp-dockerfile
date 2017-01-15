FROM php:7.0-fpm

# Install packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    imagemagick \
    libmagickwand-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
  && apt-get clean \
  && apt-get autoremove -y

RUN docker-php-ext-install exif iconv mbstring mcrypt mysqli pdo_mysql opcache pdo zip
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd
RUN yes | pecl install apcu
RUN yes | pecl install imagick-beta
RUN yes | pecl install redis-3.1.0 \
  && docker-php-ext-enable redis
#RUN echo | pecl install imagick-beta \
#  && pear channel-discover pear.twig-project.org \
#  &&pear install twig/CTwig


COPY src/conf/php/php.ini /usr/local/etc/php/php.ini
COPY src/conf/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY src/commands/start /usr/local/bin/start
RUN chmod 755 /usr/local/bin/start
CMD ["/usr/local/bin/start"]

FROM php:7.1-apache

ARG user
ARG uid
ARG TZ=Europe/rome

ENV TZ ${TZ}

RUN a2enmod rewrite
RUN a2enmod expires
RUN a2enmod headers

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    wget \
    iputils-ping \
    iproute2 \
    procps \
    libc-client-dev \
    libkrb5-dev \
    vim \
    gnupg \
    sudo \
    unzip

RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs
RUN npm install

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install zip pdo_mysql mbstring exif pcntl bcmath gd soap mysqli

# Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY docker/conf/php.ini /usr/local/etc/php
COPY docker/conf/apache2.conf /etc/apache2/

RUN mkdir /home/$user
RUN useradd -G www-data -u $uid -d /home/$user $user
RUN chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


USER $user
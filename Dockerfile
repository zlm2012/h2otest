FROM ubuntu:xenial

RUN apt-get update && apt-get install curl software-properties-common python-software-properties nodejs npm memcached redis-server libstdc++-5-dev -y \
 && apt-add-repository --yes ppa:ubuntu-toolchain-r/test \
 && apt-get --yes update \
 && apt-get install --yes cmake cmake-data g++ php-cgi wget build-essential perl ruby2.3-dev bison pkg-config git \
 && export CXX="g++" \
 && $CXX --version \
 && apt-get install -qq cpanminus libipc-signal-perl liblist-moreutils-perl libwww-perl libio-socket-ssl-perl zlib1g-dev

ADD deps/h2o/misc /root/misc

WORKDIR /root

ENV CXX=g++

RUN apt-get install automake autoconf libtool sudo python-dev libxml2-dev libc-ares-dev -y \
 && curl -L https://github.com/libuv/libuv/archive/v1.0.0.tar.gz | tar xzf - \
 && (cd libuv-1.0.0 && ./autogen.sh && ./configure --prefix=/usr && make && sudo make install) \
 && misc/install-perl-module.pl Net::EmptyPort \
 && misc/install-perl-module.pl Scope::Guard \
 && misc/install-perl-module.pl Plack \
 && misc/install-perl-module.pl FCGI \
 && misc/install-perl-module.pl http://search.cpan.org/CPAN/authors/id/A/AR/ARODLAND/FCGI-ProcManager-0.25.tar.gz \
 && misc/install-perl-module.pl Starlet \
 && misc/install-perl-module.pl JSON \
 && misc/install-perl-module.pl Path::Tiny \
 && misc/install-perl-module.pl Test::Exception \
 && apt-get install -qq apache2-utils \
 && apt-get install -qq libev-dev \
 && curl -L https://github.com/tatsuhiro-t/nghttp2/releases/download/v1.4.0/nghttp2-1.4.0.tar.gz | tar xzf - \
 && (cd nghttp2-1.4.0 && ./configure --prefix=/usr --disable-threads --enable-app && make && sudo make install) \
 && curl -L https://curl.haxx.se/download/curl-7.50.0.tar.gz | tar xzf - \
 && (cd curl-7.50.0 && ./configure --prefix=/usr --with-nghttp2 --disable-shared && make && sudo make install)

RUN useradd -s /bin/bash user \
 && wget -O /bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 \
 && chmod +x /bin/dumb-init 

ADD run.sh /run.sh
ADD build.sh /build.sh
CMD [ "/run.sh" ]

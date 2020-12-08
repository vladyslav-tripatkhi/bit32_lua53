FROM debian:9

LABEL maintainer="vladyslav-tripatkhi"

ARG lua_version=5.3.5
ARG luarocks_version=2.4.4
ARG build_dependencies='wget unzip build-essential ca-certificates'

WORKDIR /opt

RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends wget ${build_dependencies} libreadline-dev \
    && wget -q https://www.lua.org/ftp/lua-${lua_version}.tar.gz -O - | tar -zx \
    && cd lua-${lua_version} \
    && sed -i -r 's/-DLUA_COMPAT_5_2//' ./src/Makefile \
    && make linux test && make install \
    && cd .. \
    && wget -q https://luarocks.github.io/luarocks/releases/luarocks-${luarocks_version}.tar.gz -O - | tar -zx \
    && cd luarocks-${luarocks_version} \
    && ./configure --with-lua-include=/usr/local/include \
    && make build && make install \
    && luarocks install bit32 \
    && apt-get -qq remove --auto-remove -y ${build_dependencies} \
    && apt-get -qq purge  --auto-remove -y ${build_dependencies} \
    && rm -rf /tmp/* /var/lib/apt/lists/* ./luarocks-${luarocks_version} ./lua-${lua_version}
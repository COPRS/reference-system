
FROM ubuntu

RUN apt update -y &&\
    apt upgrade -y &&\
    apt install -y curl &&\
    curl -O -L https://github.com/jgm/pandoc/releases/download/2.14.2/pandoc-2.14.2-1-amd64.deb &&\
    apt install -y ./pandoc-2.14.2-1-amd64.deb &&\
    rm pandoc-2.14.2-1-amd64.deb &&\
    apt-get clean autoclean &&\
    apt-get autoremove --yes &&\
    rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN apt-get -q --no-allow-insecure-repositories update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install --assume-yes --no-install-recommends \
       ca-certificates=* \
       liblua5.3-0=5.3.3* \
       lua-lpeg=1.0.* \
       libatomic1=10* \
       libgmp10=2:6.* \
       libpcre3=2:8.39-* \
       libyaml-0-2=0.2.* \
       zlib1g=1:1.2.11.* \
       rm -rf /var/lib/apt/lists/* &&\
       rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN apt-get -q --no-allow-insecure-repositories update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install --assume-yes --no-install-recommends \
        libfreetype6 \
        libfontconfig1 \
        fontconfig \
        gnupg \
        gzip \
        librsvg2-bin \
        perl \
        tar \
        wget \
        xzdec &&\
        rm -rf /var/lib/apt/lists/* &&\
        rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV PATH="/opt/texlive/texdir/bin/x86_64-linux:${PATH}"
WORKDIR /root

RUN curl -O -L https://raw.githubusercontent.com/pandoc/dockerfiles/master/common/latex/texlive.profile &&\
    curl -O -L https://raw.githubusercontent.com/pandoc/dockerfiles/master/common/latex/install-texlive.sh &&\
    /root/install-texlive.sh &&\
    curl -O -L https://raw.githubusercontent.com/pandoc/dockerfiles/master/common/latex/install-tex-packages.sh &&\
    /root/install-tex-packages.sh &&\
    rm -f /root/texlive.profile \
          /root/install-texlive.sh \
          /root/install-tex-packages.sh

WORKDIR /data
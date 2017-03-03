FROM debian:jessie

ENV EDITOR vim
ENV SHELL zsh
ENV TERM screen-256color-bce

RUN apt-get update
RUN apt-get install -y \
  build-essential \
  ca-certificates \
  cmake \
  curl \
  git \
  jq \
  libx11-dev \
  libxtst-dev \
  libxt-dev \
  libsm-dev \
  libxpm-dev \
  ncurses-dev \
  python3-dev \
  silversearcher-ag \
  zsh

WORKDIR /root

RUN curl -LO https://github.com/vim/vim/archive/master.tar.gz && \
  tar -zxvf master.tar.gz && \
  cd vim-master/src && \

  ./configure --prefix=/usr \
              --with-x \
              --enable-gui \
              --enable-python3interp \
              --with-python3-config-dir=/usr/lib/python3.4/config-3.4m-x86_64-linux-gnu && \
  make && \
  make install

ADD .vim .vim
RUN python3 .vim/pack/foo/start/YouCompleteMe/install.py
ADD .vimrc .vimrc
ADD .gitconfig .gitconfig
ADD prezto .zprezto
RUN for rcfile in $(ls .zprezto/runcoms | grep z); do \
    ln -s ".zprezto/runcoms/$rcfile" ".$rcfile"; \
  done

WORKDIR /project
CMD zsh

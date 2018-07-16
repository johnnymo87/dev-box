FROM debian:stretch

ENV EDITOR vim
ENV SHELL zsh
ENV TERM screen-256color-bce

RUN apt-get update
RUN apt-get install -y \
  # For building from source
  cmake \
  ncurses-dev \
  # For curling other dependencies
  curl \
  # For using zpresto's git functionality
  git \
  # Because I like using jq
  jq \
  # Because I like using zsh
  zsh

WORKDIR /root

# Install vim from source
RUN curl -LO https://github.com/vim/vim/archive/master.tar.gz && \
  tar -zxvf master.tar.gz && \
  cd vim-master/src && \

  ./configure --prefix=/usr \
              --with-x \
              --enable-gui && \
  make && \
  make install


# Fetch and install the ripgrep package
# https://github.com/BurntSushi/ripgrep
RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.8.1/ripgrep_0.8.1_amd64.deb && \
  dpkg -i ripgrep_0.8.1_amd64.deb

ADD .vim .vim
ADD .vimrc .vimrc
ADD .gitconfig .gitconfig
ADD prezto .zprezto
RUN for rcfile in $(ls .zprezto/runcoms | grep z); do \
    ln -s ".zprezto/runcoms/$rcfile" ".$rcfile"; \
  done

WORKDIR /project
CMD zsh

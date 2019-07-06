FROM centos:7.6.1810

ENV LANG=en_GB.UTF-8 \
    VER_ERLANG="22.0.4" \
    VER_ELIXIR="1.9.0" \
    VER_NODE="10.16.0"

RUN set -xe \
    && yum update -y \
    && yum install wget git unzip -y

# Erlang
RUN wget https://github.com/rabbitmq/erlang-rpm/releases/download/v${VER_ERLANG}/erlang-${VER_ERLANG}-1.el7.x86_64.rpm \
    && yum localinstall erlang-${VER_ERLANG}-1.el7.x86_64.rpm -y \
    && rm erlang-${VER_ERLANG}-1.el7.x86_64.rpm

# Elixir
RUN wget https://github.com/elixir-lang/elixir/releases/download/v${VER_ELIXIR}/Precompiled.zip \
    && unzip Precompiled.zip -d /opt/elixir \
    && rm /Precompiled.zip \
    && echo -e '\nexport PATH=/opt/elixir/bin:$PATH' >> ~/.bashrc

# Node
RUN wget https://nodejs.org/dist/v${VER_NODE}/node-v${VER_NODE}-linux-x64.tar.xz \
    && tar xf node-v${VER_NODE}-linux-x64.tar.xz \
    && mv node-v${VER_NODE}-linux-x64 /opt/node \
    && rm node-v${VER_NODE}-linux-x64.tar.xz \
    && echo -e '\nexport PATH=/opt/node/bin:$PATH' >> ~/.bashrc

ENV PATH=/opt/elixir/bin:/opt/node/bin:$PATH


CMD ["/bin/bash"]

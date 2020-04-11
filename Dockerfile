FROM amazonlinux:2

ENV VERSION_ELM=0.19.1
ENV VERSION_NODE=12.10.0

# install curl, git, openssl (AWS Amplify requirements)
# install tar, xz (nodejs install requirements)
RUN yum -y update && \
    yum -y install curl git openssl tar xz && \
    yum clean all && \
    rm -fr /var/cache/yum

# Install Node (AWS Amplify and elm-repl requirements)
RUN mkdir -p /opt/nodejs && \
    curl -L -o- https://nodejs.org/dist/v${VERSION_NODE}/node-v${VERSION_NODE}-linux-x64.tar.xz | tar -xJvf- -C /opt/nodejs

# Rather than updating PATH env, symlink node,npm,npx to /usr/local/bin
RUN ln -s /opt/nodejs/node-v${VERSION_NODE}-linux-x64/bin/{node,npm,npx} /usr/local/bin/

# Install Elm
RUN curl -L -o- https://github.com/elm/compiler/releases/download/${VERSION_ELM}/binary-for-linux-64-bit.gz | gunzip > /usr/local/bin/elm && \
    chmod +x /usr/local/bin/elm

CMD ["/usr/local/bin/elm", "repl"]

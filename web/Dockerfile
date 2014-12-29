#
# MetaMind Dev
#

FROM dockerfile/nodejs

MAINTAINER Daniel Sont "dan.sont@gmail.com"

# create node user
RUN useradd -ms /bin/bash node
RUN mkdir /src /dist && chown -R node:node /dist /src

USER node
ENV HOME /home/node
RUN mkdir ~/.npm-packages && npm config set prefix ~/.npm-packages
ENV NPM_PACKAGES ~/.npm-packages
ENV NODE_PATH $NPM_PACKAGES/lib/node_modules:$NODE_PATH
ENV PATH $NPM_PACKAGES/bin:$PATH
ENV MANPATH $NPM_PACKAGES/share/man:$MANPATH

RUN npm install -g gulp

COPY docker-main.sh /home/node/

WORKDIR /home/node
CMD /bin/bash docker-main.sh

VOLUME /src
VOLUME /dist
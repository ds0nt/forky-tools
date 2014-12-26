#
# MetaMind Dev
#

FROM dockerfile/nodejs

MAINTAINER Daniel Sont "dan.sont@gmail.com"
 
EXPOSE 8080

# create node user
RUN useradd -ms /bin/bash node

RUN chown -R node:node /home/node

USER node
ENV HOME /home/node

RUN mkdir ~/.npm-packages && \
	npm config set prefix ~/.npm-packages

ENV NPM_PACKAGES ~/.npm-packages
ENV NODE_PATH $NPM_PACKAGES/lib/node_modules:$NODE_PATH
ENV PATH $NPM_PACKAGES/bin:$PATH

ENV MANPATH $NPM_PACKAGES/share/man:$MANPATH

ADD app /home/node/app

WORKDIR /home/node/app
CMD /bin/bash -c node\ index.js

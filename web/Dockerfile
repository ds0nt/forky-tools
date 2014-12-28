#
# MetaMind Dev
#

FROM dockerfile/nodejs

MAINTAINER Daniel Sont "dan.sont@gmail.com"

RUN mkdir /mm-web
VOLUME /mm-web

RUN npm install -g gulp

WORKDIR /mm-web
CMD /bin/bash -c gulp\ watch --verbose=true
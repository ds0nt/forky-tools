#
# MetaMind Dev
#

FROM dockerfile/nodejs

MAINTAINER Daniel Sont "dan.sont@gmail.com"
 

RUN git clone https://github.com/21cdawn/metamind-server /app
RUN cd /app && npm install

WORKDIR /app
CMD /bin/bash -c node\ index.js

EXPOSE 8080

FROM jketterl/openwebrx:latest
MAINTAINER af@0xaf.org
LABEL OpenWebRX + Digital codecs (mbelib), using codecserver-softmbe.


COPY integrate-softmbe.sh /
RUN /integrate-softmbe.sh




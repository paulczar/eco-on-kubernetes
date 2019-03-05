FROM mono:latest

CMD ["mono", "/ecoserver/EcoServer.exe", "-nogui"]

EXPOSE 3000/udp 3001

RUN \
  apt-get -q update && \
  apt-get install -yq vim jq

WORKDIR /ecoserver

COPY server /ecoserver

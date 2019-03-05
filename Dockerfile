FROM mono:5.18
LABEL maintainer="Paul Czarkowski"

#Avoids prompts for input
ENV DEBIAN_FRONTEND noninteractive

#Variables containing the default values for the variables that can be changed in the docker-compose file
# ENV WORLD_SIZE_X WORLD_SIZE_Y METEOR_IMPACT_DAYS

CMD ["/ecoserver/linux.sh"]

EXPOSE 3000/udp 3001

RUN \
    apt-get -q update && \
    apt-get install -yq jq moreutils uuid-runtime vim

WORKDIR /ecoserver


COPY server /ecoserver

RUN \
    useradd -rm -d /ecoserver -s /bin/bash -u 1000 eco && \
    mv /ecoserver/Configs /ecoserver/Configs.default && \
    mv /ecoserver/Storage /ecoserver/Storage.default && \
    mkdir /data && \
    chmod +x /ecoserver/linux.sh && \
    chown -R eco /ecoserver && \
    chown -R eco /data
USER eco

COPY linux.sh /ecoserver/linux.sh

FROM debian:bullseye-slim
LABEL org.opencontainers.image.source https://github.com/kesokaj/valheim-server

COPY init.sh /init.sh
RUN chmod +x /init.sh

ENV SERVER_NAME valheim
ENV SERVER_PASSWORD secret
ENV WORLD_NAME Dedicated

RUN adduser \
	--home /home/steam \
	--disabled-password \
	--shell /bin/bash \
	--gecos "user for running steam" \
	--quiet \
	steam

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y \
        vim sudo net-tools iproute2 lsof curl wget lib32gcc-s1 lib32stdc++6 \
        nano software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir -p /opt/steamcmd &&\
    cd /opt/steamcmd &&\
    curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -vxz &&\
    chown -R steam /opt/steamcmd

RUN echo "steam ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

USER steam
WORKDIR /home/steam

RUN /opt/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +force_install_dir /home/steam +login anonymous +app_update 896660 validate +quit

RUN sed -i 's/My server/${SERVER_NAME}/g' start_server.sh
RUN sed -i 's/secret/${SERVER_PASSWORD}/g' start_server.sh
RUN sed -i 's/Dedicated/${WORLD_NAME}/g' start_server.sh

ENTRYPOINT ["/init.sh"]

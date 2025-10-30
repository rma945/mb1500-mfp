FROM node:25.0.0-alpine3.22 AS builder

ENV SCANSERV_GIT_URL="https://github.com/sbs20/scanservjs.git" \
    SCANSERV_GIT_REF="master"

RUN apk add --no-cache git
WORKDIR /src
RUN git clone --single-branch --depth 1 --branch "${SCANSERV_GIT_REF}" "${SCANSERV_GIT_URL}" . && \
    npm install && npm run build &&\
    cd ./dist && npm install --omit=dev

FROM debian:bookworm-20251020 AS final

LABEL maintainer="rma945" \
      org.opencontainers.image.title="scan-print-box" \
      org.opencontainers.image.description="Container image with Panasonic MB1500 drivers and additional software"

ENV SCANNER_DRIVER_URL="https://www.psn-web.net/cs/support/fax/common/file/Linux_ScanDriver/panamfs-scan-1.3.1-x86_64.tar.gz" \
    PRINTER_DRIVER_URL="https://www.psn-web.net/cs/support/fax/common/file/Linux_PrnDriver/Driver_Install_files/mccgdi-2.0.10-x86_64.tar.gz" \
    SCANSERVJS_URL="https://github.com/sbs20/scanservjs/releases/download/v3.0.4/scanservjs_3.0.4-1_all.deb" \
    NODEJS_URL="https://nodejs.org/dist/v25.0.0/node-v25.0.0-linux-x64.tar.xz"

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-amd64-installer /src/

COPY --chmod=744 rootfs/cleanup.sh /src/
COPY --chown=scanserver:scanserver --from=builder /src/dist/ /opt/scanserver

RUN apt update &&\
    apt install -y --no-install-recommends cups sane sane-utils imagemagick libusb-0.1-4 usbutils \
    xz-utils curl libatomic1 &&\
    chmod +x /src/s6-overlay-amd64-installer && /src/s6-overlay-amd64-installer / &&\

    ###  install scanner drivers
    mkdir -p /src/scanner/ &&\
    curl -kL ${SCANNER_DRIVER_URL} | tar --strip-components=1 -xzvf - -C /src/scanner/ &&\
    /src/scanner/install-driver &&\

    ### install printer drivers
    mkdir /src/printer/ &&\
    ln -s /usr/lib/x86_64-linux-gnu/libgs.so.10 /usr/lib64/libgs.so &&\
    curl -kL ${PRINTER_DRIVER_URL} | tar --strip-components=1 -xzvf - -C /src/printer/ &&\
    /src/printer/install-driver &&\

    ### install scanservjs
    useradd -d /opt/scanserver/ -s /bin/false -r scanserver && usermod -G lp scanserver &&\
    mkdir -p /opt/node && curl -kL ${NODEJS_URL} | tar --strip-components=1 -xJvf - -C /opt/node/ &&\

    ### cleanup
   /src/cleanup.sh && rm -rf /src/ && apt clean

COPY rootfs /

ENV PATH=/opt/node/bin:$PATH \
    SANE_DEVICE_NAME='KX-MB1500' \
    CUPS_ADMIN_USER='printer' \
    CUPS_ADMIN_PASSWORD='printer'

EXPOSE 8190/tcp \
       631/tcp \
       5353/udp

ENTRYPOINT ["/init"]

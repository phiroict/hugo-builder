ARG HUGO_VERSION=0.62.2
ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS builder

ARG HUGO_VERSION
ARG GIT_VERSION=~2.24.1

RUN apk --no-cache add \
  git=$GIT_VERSION

WORKDIR /usr/local/src

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN wget https://github.com/gohugoio/hugo/releases/download/v"${HUGO_VERSION}"/hugo_"${HUGO_VERSION}"_Linux-64bit.tar.gz

RUN wget https://github.com/gohugoio/hugo/releases/download/v"${HUGO_VERSION}"/hugo_"${HUGO_VERSION}"_checksums.txt \
  && sed -i '/hugo_[0-9].*Linux-64bit.tar.gz/!d' hugo_${HUGO_VERSION}_checksums.txt \
  && sha256sum -cs hugo_${HUGO_VERSION}_checksums.txt \
  && tar -xzvf hugo_"${HUGO_VERSION}"_Linux-64bit.tar.gz

FROM alpine:${ALPINE_VERSION}

ARG HUGO_VERSION
ARG TINI_VERSION=~0.18.0

ARG PGID=1000
ARG PUID=1000

ARG TAG_REF=$HUGO_VERSION
ARG CREATE_DATE
ARG REVISION
ARG BUILD_VERSION

LABEL maintainer="engineering@catosplace.co.nz"

LABEL org.opencontainers.image.create_date=$CREATE_DATE
LABEL org.opencontainers.image.authors="engineering@catosplace.co.nz"
LABEL org.opencontainers.image.title="hugo_builder"
LABEL org.opencontainers.image.description="Hugo website builder" 
LABEL org.opencontainers.image.documentation="https://github.com/catosplace/hugo-builder/${HUGO_VERSION}/README.md"
LABEL org.opencontainers.image.url="https://dockerhub.com/catosplace/hugo-builder"
LABEL org.opencontainers.image.source="https://github.com/catosplace/hugo-builder"
LABEL org.opencontainers.image.revision=$REVISION 
LABEL org.opencontainers.image.vendor="Catosplace"
LABEL org.opencontainers.image.version=$BUILD_VERSION 
LABEL org.opencontainers.image.licenses="Apache-2.0" 

LABEL org.label-schema.docker.cmd="docker run --rm -it -v $PWD:/src catosplace/hugo-builder hugo"
LABEL org.label-schema.docker.cmd.debug="docker exec -it $CONTAINER /bin/sh"
LABEL org.label-schema.docker.cmd.help="docker exec -it $CONTAINER hugo -h"

RUN apk --no-cache add \
  tini=${TINI_VERSION}

COPY --from=builder /usr/local/src/hugo /usr/local/bin/

RUN addgroup -Sg $PGID hugo \
  && adduser -SG hugo -u $PUID -h /src hugo

USER hugo

WORKDIR /src

EXPOSE 1313
ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/bin/sh"]

HEALTHCHECK --interval=10s --timeout=10s --start-period=15s \
  CMD hugo env || exit 1 

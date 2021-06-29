FROM quay.io/bitnami/golang:1.16 AS build

ARG YTT_VERSION=develop
WORKDIR /go/src/github.com/k14s/ytt
RUN echo building ytt $YTT_VERSION \
 && git clone \
        --branch "${YTT_VERSION}" \
        --single-branch \
        --depth 1 \
        https://github.com/k14s/ytt \
        . \
 && apt-get update && apt-get install -y --no-install-recommends zip=3.0* \
 && ./hack/build.sh


FROM quay.io/oo00spy00oo/minideb:buster

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /go/src/github.com/k14s/ytt/ytt /usr/bin/ytt

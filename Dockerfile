FROM docker.io/library/node:lts-alpine as builder

RUN npm install \
    --prefix /verdaccio/plugins \
    --install-strategy=shallow \
    --no-bin-links \
    --no-save \
    --no-package-lock \
    --omit=dev \
    # verdaccio-github-oauth-ui@latest \
    verdaccio-aws-s3-storage@latest


FROM docker.io/verdaccio/verdaccio:latest

USER root

RUN npm install --global verdaccio-github-oauth-ui

# COPY --from=builder /verdaccio/plugins/node_modules/verdaccio-github-oauth-ui /verdaccio/plugins/verdaccio-github-oauth-ui
COPY --from=builder /verdaccio/plugins/node_modules/verdaccio-aws-s3-storage /verdaccio/plugins/verdaccio-aws-s3-storage
COPY config.yaml /verdaccio/conf/config.yaml

USER $VERDACCIO_USER_UID

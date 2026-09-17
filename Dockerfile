FROM alpine:3.17.3

RUN apk add --no-cache ser2net=4.6.4-r0
COPY entrypoint.sh /entrypoint.sh

EXPOSE 2000
ENV PORT=2000 \
    STATE=raw \
    TIMEOUT=0 \
    DEVICE_OPTIONS=

CMD ["/entrypoint.sh"]

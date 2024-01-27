FROM alpine:3.19.1

RUN apk add --no-cache ser2net=3.5.1-r1
COPY entrypoint.sh /entrypoint.sh

EXPOSE 2000
ENV PORT=2000 \
    STATE=raw \
    TIMEOUT=0 \
    DEVICE_OPTIONS=

CMD ["/entrypoint.sh"]

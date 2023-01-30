FROM busybox:latest

COPY getwp.sh /root/getwp.sh

RUN mkdir -p /usr/share/nginx/
RUN chmod +x /root/getwp.sh
RUN sh /root/getwp.sh

CMD ["sh" ]

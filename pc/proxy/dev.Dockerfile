FROM alpine:3.14@sha256:234cb88d3020898631af0ccbbcca9a66ae7306ecd30c9720690858c1b007d2a0 as init

ARG WORK_DIR="/opt/processing"
ARG SUBJ="/C=FR/ST=AM/L=SophiaAntipolis/O=COMAPNY_NAME/OU=R&D/CN=test.domain.com"
RUN mkdir -p $WORK_DIR


WORKDIR $WORK_DIR


RUN apk add --update openssl \
    && openssl req -x509 -newkey rsa:4096 -nodes -out public.crt -keyout private.key -days 365 -subj $SUBJ



## ***** NGINX *****

FROM nginx:1.21-alpine@sha256:6d76a25a64f6a9a873bded796761bf7a1d18367570281d73d16750ce37fae297

LABEL maintainer="NM <n.maltsev@gmail.com>" \
	org.opencontainers.image.title="strapi-demo/proxy" \
	org.opencontainers.image.description="TODO"


RUN mkdir -p /opt/app
COPY ./start.sh /opt/app/
COPY ./nginx.dev.conf /etc/nginx/conf.d/default.conf
COPY ./html/ /usr/share/nginx/html/
COPY --from=init /opt/processing/public.crt /etc/nginx/conf.d/certs/
COPY --from=init /opt/processing/private.key /etc/nginx/conf.d/certs/


RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && chmod +x /opt/app/start.sh


EXPOSE 80
EXPOSE 443
STOPSIGNAL SIGTERM

CMD ["/opt/app/start.sh"]

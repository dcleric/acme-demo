FROM alpine:3.8

LABEL description="Sample SSL app" \
      maintainer="dcleric@gmail.com>"

USER nobody

COPY acme-demo/licensing_serivce /licensing_service

CMD ["/licensing_service", "--host=dev"]


FROM alpine:3.8

LABEL description="Sample SSL app" \
      maintainer="dcleric@gmail.com>"

USER nobody

COPY gen_cert /gen_cert

COPY root_cert.pem.gz /root_cert.pem.gz

CMD ["/gen_cert", "--host=dev"]


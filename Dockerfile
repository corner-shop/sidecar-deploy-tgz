FROM alpine
RUN apk update && apk add tar gzip
ENV TGZ "tar czf - . | base64 -w0"
ENV WORKDIR /tmp
CMD cd $WORKDIR && ( echo "$TGZ" | base64 -d | tar xzf - ) && find $WORKDIR && sleep 2147483647d

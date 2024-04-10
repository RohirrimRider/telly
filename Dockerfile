FROM docker.io/golang:latest as build
ADD . /app
WORKDIR /app
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64
RUN go build -a -ldflags '-extldflags "-static" -s -w' -o /usr/local/bin/telly .
RUN chmod a+x /usr/local/bin/telly

FROM alpine
RUN apk add dumb-init ffmpeg
COPY --from=build /usr/local/bin/telly /usr/local/bin/telly
EXPOSE 6077
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/local/bin/telly"]

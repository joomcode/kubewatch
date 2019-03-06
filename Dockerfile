FROM golang:alpine AS builder
MAINTAINER "Ivan Kukharchuk <kukharchuk@joom.com>"

RUN apk update && \
    apk add git build-base && \
    rm -rf /var/cache/apk/* && \
    mkdir -p "$GOPATH/src/github.com/joomcode/kubewatch"

ADD . "$GOPATH/src/github.com/joomcode/kubewatch"

RUN cd "$GOPATH/src/github.com/joomcode/kubewatch" && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a --installsuffix cgo --ldflags="-s" -o /kubewatch

FROM alpine:3.6
RUN apk add --update ca-certificates

COPY --from=builder /kubewatch /bin/kubewatch

ENTRYPOINT ["/bin/kubewatch"]

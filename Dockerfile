FROM golang:1.22.1-alpine3.19 as builder

ENV GOPROXY=https://goproxy.cn CGO_ENABLED=0

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && apk update && apk add --no-cache git

RUN git clone https://ghproxy.net/https://github.com/fatedier/frp.git /build

WORKDIR /build

RUN go build -trimpath -ldflags "-s -w" -tags frps -o frps ./cmd/frps
RUN go build -trimpath -ldflags "-s -w" -tags frps -o frpc ./cmd/frpc


FROM alpine:3.19

WORKDIR /app

COPY --from=builder /build/frps /usr/bin/frps
COPY --from=builder /build/frpc /usr/bin/frpc




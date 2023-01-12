FROM golang:1.19.2 as builder
WORKDIR /home/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o bin/ ./...

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /home/bin/hello-world ./
EXPOSE 80 443
CMD ["./hello-world"]
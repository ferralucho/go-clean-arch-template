# Step 1: Modules caching
FROM golang:1.18.2-alpine3.14@sha256:70ba8ec1a0e26a828c802c76ecfc65d1efe15f3cc04d579747fd6b0b23e1cea5 as modules
COPY go.mod go.sum /modules/
WORKDIR /modules
RUN go mod download

# Step 2: Builder
FROM golang:1.18.2-alpine3.14@sha256:70ba8ec1a0e26a828c802c76ecfc65d1efe15f3cc04d579747fd6b0b23e1cea5 as builder
COPY --from=modules /go/pkg /go/pkg
COPY . /app
WORKDIR /app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -tags migrate -o /bin/app ./cmd/app

# Step 3: Final
FROM scratch
COPY --from=builder /app/config /config
COPY --from=builder /app/migrations /migrations
COPY --from=builder /bin/app /app
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
CMD ["/app"]
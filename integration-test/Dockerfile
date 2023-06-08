# Step 1: Modules caching
FROM golang:1.18.2-alpine3.14@sha256:70ba8ec1a0e26a828c802c76ecfc65d1efe15f3cc04d579747fd6b0b23e1cea5 as modules
COPY go.mod go.sum /modules/
WORKDIR /modules
RUN go mod download

# Step 2: Tests
FROM golang:1.18.2-alpine3.14@sha256:70ba8ec1a0e26a828c802c76ecfc65d1efe15f3cc04d579747fd6b0b23e1cea5
COPY --from=modules /go/pkg /go/pkg
COPY . /app
WORKDIR /app

RUN go env -w CGO_ENABLED=0
RUN go env -w GOOS=linux
RUN go env -w GOARCH=amd64

CMD ["go", "test", "-v", "./integration-test/..."]
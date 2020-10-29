# Build the manager binary
FROM golang:1.15 as builder

WORKDIR /devops

COPY go.mod go.mod
COPY cmd/ cmd/

RUN go mod download

# Build
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -a -o devops-go-sample cmd/main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM alpine:3.9
WORKDIR /devops
COPY --from=builder /devops/devops-go-sample .

ENTRYPOINT ["./devops-go-sample"]

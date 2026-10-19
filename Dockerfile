FROM --platform=$BUILDPLATFORM golang:1.25-alpine AS build
ARG TARGETARCH
WORKDIR /src
COPY go.mod main.go main_test.go ./
RUN go test ./...
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -trimpath -ldflags="-s -w" -o /out/hello .

FROM scratch
COPY --from=build /out/hello /hello
EXPOSE 8080
ENTRYPOINT ["/hello"]

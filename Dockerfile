FROM alpine AS builder

RUN apk add curl jq

RUN download_url=$(curl -s https://api.github.com/repos/go-swagger/go-swagger/releases/latest | \
    jq -r '.assets[] | select(.name | contains("'"$(uname | tr '[:upper:]' '[:lower:]')"'_amd64")) | .browser_download_url') && \
    curl -o /usr/local/bin/swagger -L'#' "$download_url" && \
    chmod +x /usr/local/bin/swagger

FROM golang:alpine

COPY --from=builder /usr/local/bin/swagger /usr/local/bin/swagger

ENTRYPOINT ["swagger"]
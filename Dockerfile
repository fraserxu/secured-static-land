FROM alpine:latest
MAINTAINER Fraser Xu <xvfeng123@gmail.com>

ENV OAUTH2_PROXY_VERSION 2.1.linux-amd64.go1.6

RUN apk --update add curl

# Install dependencies
RUN curl -sL -o oauth2_proxy.tar.gz \
    "https://github.com/bitly/oauth2_proxy/releases/download/v2.1/oauth2_proxy-$OAUTH2_PROXY_VERSION.tar.gz" \
  && tar xzvf oauth2_proxy.tar.gz \
  && mv oauth2_proxy-$OAUTH2_PROXY_VERSION/oauth2_proxy ./bin/ \
  && chmod +x ./bin/oauth2_proxy \
  && rm -r oauth2_proxy*

# Copy static files
ADD ./static .
ADD oauth2_proxy.cfg .
WORKDIR .

# Run the image as a non-root user
RUN adduser -D static
USER static

# Run the app.
CMD ./bin/oauth2_proxy -http-address="0.0.0.0:$PORT" -config="./oauth2_proxy.cfg"

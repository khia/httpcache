# to build:
#   docker build -t httpcache .
# to run:
#   docker run -i -t httpcache
FROM ubuntu
RUN	apt-get -y update && apt-get -y install wget curl git python-software-properties
RUN add-apt-repository ppa:gophers/go && apt-get -y update && apt-get install golang-stable
RUN go get github.com/pwaller/httpcache && go build github.com/pwaller/httpcache
RUN openssl genpkey -algorithm rsa -out mitm-ca.key -pkeyopt rsa_keygen_bits:4096 && \
  openssl req -new -x509 -days 365 -key mitm-ca.key -out mitm-ca.crt -subj "/O=httpcache\/$(whoami)/" && \
  cp mitm-ca.crt /usr/local/share/ca-certificates/httpcache-tmp-mitm.crt && \
  update-ca-certificates

CMD ["/httpcache"]
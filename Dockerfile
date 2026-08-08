FROM mongo:8.2

ENV CRON_TIME="0 3 * * *" \
  TZ=Australia/Adelaide \
  CRON_TZ=Australia/Adelaide

# Install cron and AWS CLI v2
RUN \
  apt-get update && \
  apt-get --assume-yes --no-install-recommends install \
    ca-certificates \
    curl \
    unzip \
    cron && \
  rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* && \
  arch="$(uname -m)" && \
  case "$arch" in \
    x86_64|aarch64) ;; \
    *) echo "unsupported architecture: $arch" >&2; exit 1 ;; \
  esac && \
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${arch}.zip" -o /tmp/awscliv2.zip && \
  unzip -q /tmp/awscliv2.zip -d /tmp && \
  /tmp/aws/install && \
  rm -rf \
    /tmp/aws \
    /tmp/awscliv2.zip

ADD run.sh /run.sh
CMD /run.sh
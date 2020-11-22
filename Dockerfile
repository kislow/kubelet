FROM docker.io/alpine:3.12 AS fetcher
LABEL maintainer="<kadirislow@gmail.com>"

ARG KUBELET=v1.18.12
ARG ARCH=amd64
ARG SHA=3874d18d1013fb38a8e2ea029dee717c5c65394513b74de87f340338f8cec4162739b8d060ca0bf2f3101403406e67bcf43560d54d74d30b85a7f701bc8d0e61

RUN apk add curl && \
  curl -L https://dl.k8s.io/${KUBELET}/kubernetes-node-linux-${ARCH}.tar.gz -o node.tar.gz && \
  echo "${SHA}  node.tar.gz" | sha512sum -c && \
  tar xzf node.tar.gz kubernetes/node/bin/kubectl kubernetes/node/bin/kubelet


FROM us.gcr.io/k8s-artifacts-prod/build-image/debian-iptables:buster-v1.3.0
LABEL maintainer="<kadirislow@gmail.com>"

RUN clean-install \
  bash \
  ca-certificates \
  ceph-common \
  cifs-utils \
  e2fsprogs \
  xfsprogs \
  ethtool \
  glusterfs-client \
  iproute2 \
  jq \
  nfs-common \
  socat \
  udev \
  util-linux

COPY --from=fetcher /kubernetes/node/bin/kubelet /usr/local/bin/kubelet
COPY --from=fetcher /kubernetes/node/bin/kubectl /usr/local/bin/kubectl
ENTRYPOINT ["/usr/local/bin/kubelet"]

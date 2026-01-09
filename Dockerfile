# Build Prime95 image that automatically fetches the second newest major stream
# (to avoid pre-release builds)
# and within it the newest Linux x64 build.
FROM debian:trixie-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/prime95

ARG GIMPS_BASE_URL=https://download.mersenne.ca/gimps

RUN set -eux; \
    base_html=$(curl -fsSL "$GIMPS_BASE_URL/"); \
    branch=$(printf '%s\n' "$base_html" \
        | grep -oE 'href="/gimps/v[0-9]+' \
        | sed 's#.*/##' \
        | sort -uV \
        | tail -n 2 \
        | head -n 1); \
    echo "Selected branch: ${branch}"; \
    [ -n "$branch" ]; \
    release_html=$(curl -fsSL "$GIMPS_BASE_URL/${branch}/"); \
    release=$(printf '%s\n' "$release_html" \
        | grep -oE "href=\"/gimps/${branch}/[0-9]+\\.[0-9]+" \
        | sed 's#.*/##' \
        | sort -uV \
        | tail -n 1); \
    echo "Selected release: ${release}"; \
    [ -n "$release" ]; \
    files_html=$(curl -fsSL "$GIMPS_BASE_URL/${branch}/${release}/"); \
    tarball=$(printf '%s\n' "$files_html" \
        | grep -oE 'href="/gimps/[^" ]*linux64\.tar\.gz"' \
        | sed 's/^href="//;s/"$//' \
        | sort -uV \
        | tail -n 1); \
    echo "Selected tarball: ${tarball}"; \
    [ -n "$tarball" ]; \
    tarball_path=${tarball#/}; \
    tarball_path=${tarball_path#gimps/}; \
    curl -fsSL "$GIMPS_BASE_URL/${tarball_path}" -o prime95.tar.gz; \
    tar -xzf prime95.tar.gz; \
    rm prime95.tar.gz

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

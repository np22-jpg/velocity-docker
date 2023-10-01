FROM docker.io/library/debian:11 AS downloader
ARG VELOCITY_VERSION="latest"

COPY . .

RUN apt-get update && \
    apt-get -y install curl jq && \
    chmod +x get_versions.sh && \
    ./get_versions.sh ${VELOCITY_VERSION}

FROM docker.io/azul/zulu-openjdk-debian:21-jre-latest AS release

LABEL org.opencontainers.image.vendor="np22-jpg"
LABEL org.opencontainers.image.title="Velocity"
LABEL org.opencontainers.image.description="Automatically built Docker image for Velocity"
LABEL org.opencontainers.image.documentation="https://github.com/np22-jpg/velocity/blob/main/README.md"
LABEL org.opencontainers.image.authors="Chao Tzu-Hsien <danny900714@gmail.com> and Nolan <npgo22@gmail.com>"
LABEL org.opencontainers.image.licenses="MIT"

ENV JAVA_MEMORY="1G"
ENV JAVA_FLAGS="-XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15"

EXPOSE 25577

WORKDIR /data

RUN mkdir /app && \
    useradd velocity && \
    chown -R velocity:velocity /data /app

COPY --from=downloader --chown=velocity:velocity entrypoint.sh velocity.jar /app/

USER velocity
ENTRYPOINT ["/app/entrypoint.sh", "/app/velocity.jar"]
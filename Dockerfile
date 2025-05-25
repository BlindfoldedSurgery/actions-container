# This is just a test file for this repo's pipeline

FROM public.ecr.aws/docker/library/debian:bookworm-slim

RUN apt-get update -qq && apt-get install -y --no-install-recommends zip && apt-get clean

ARG APP_VERSION
RUN if [ -z "$APP_VERSION" ]; then exit 1; fi;

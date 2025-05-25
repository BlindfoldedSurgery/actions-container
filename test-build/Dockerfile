# This is just a test file for this repo's pipeline

FROM debian:bookworm-slim AS real

RUN apt-get update -qq && apt-get install -y --no-install-recommends jq && apt-get clean

ARG APP_VERSION
RUN if [ -z "$APP_VERSION" ]; then exit 1; fi;

ARG MY_BUILD_ARG_ONE
RUN if [ -z "$MY_BUILD_ARG_ONE" ]; then exit 1; fi;

ARG MY_BUILD_ARG_TWO
RUN if [ -z "$MY_BUILD_ARG_TWO" ]; then exit 1; fi;

FROM debian:bookworm-slim AS fake

RUN exit 1

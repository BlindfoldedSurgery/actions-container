# This is just a test file for this repo's pipeline

FROM public.ecr.aws/docker/library/debian:bookworm-slim AS real

RUN apt-get update -qq && apt-get install -y --no-install-recommends jq && apt-get clean

ARG APP_VERSION
RUN if [ -z "$APP_VERSION" ]; then exit 1; fi;

ARG MY_BUILD_ARG_ONE
RUN if [ "$MY_BUILD_ARG_ONE" != "test" ]; then exit 1; fi;

ARG MY_BUILD_ARG_TWO
RUN if [ "$MY_BUILD_ARG_TWO" != "test2" ]; then exit 1; fi;

FROM public.ecr.aws/docker/library/debian:bookworm-slim AS fake

RUN exit 1

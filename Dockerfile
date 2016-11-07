FROM elixir:1.3.0

ENV MIX_ENV=prod
ENV PORT=80
ENV POOL_SIZE=18
ENV READ_TOKEN=dummy-token
ENV WRITE_TOKEN=dummy-token
WORKDIR /app

ADD . /app
RUN mix local.hex --force
RUN mix deps.get
RUN mix compile
RUN mix phoenix.digest

EXPOSE 80
CMD mix phoenix.server

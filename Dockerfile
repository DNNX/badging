FROM elixir:1.8.0
ARG POOL_SIZE
ARG READ_TOKEN
ARG WRITE_TOKEN
ARG HOST

ENV MIX_ENV=prod
ENV PORT=80
ENV POOL_SIZE ${POOL_SIZE:-10}
ENV READ_TOKEN ${READ_TOKEN}
ENV WRITE_TOKEN ${WRITE_TOKEN}
ENV HOST ${HOST}
WORKDIR /app

ADD . /app
RUN mix local.hex --force
RUN mix deps.get
RUN mix compile
RUN mix phoenix.digest

EXPOSE 80
CMD mix ecto.migrate && mix phx.server

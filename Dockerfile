FROM ubuntu:25.04
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN apt update && apt upgrade -y && apt install -y git python3 python3-pip curl
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

COPY . /app
WORKDIR /app
#RUN git clone https://github.com/open-webui/mcpo.git && cd mcpo

ENV VIRTUAL_ENV=/app/.venv
RUN uv venv "$VIRTUAL_ENV"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"


RUN uv pip install mcpo
RUN npm install @modelcontextprotocol/server-memory

ENV MEMORY_FILE_PATH=/app/memory.json
CMD ["sh", "-c", "uvx mcpo --port 3000 -- npx @modelcontextprotocol/server-memory"]
EXPOSE 3000

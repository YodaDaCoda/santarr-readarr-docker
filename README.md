This repo contains docker files allowing running Readarr with a custom metadata server via docker compose.

You must first edit docker-compose.yml and set METADATA_SERVER to the full URL of the custom metadata server.

You can then start Readarr with the following command:

docker compose up --build -d

By default it listens on port 8788 in order to not conflict with any existing Readarr instances.

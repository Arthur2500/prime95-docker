# prime95-docker

Containerisiert Prime95. Beim Build wird automatisch der zweitneueste Major-Ordner aus https://download.mersenne.ca/gimps/ gewählt (z.B. v30), darin die neueste Version (z.B. 30.19) und daraus das neueste linux64-Tarball geladen und entpackt.

## Nutzung
- Build & Start: `docker compose up --build`
- Flags anpassen: `PRIME95_FLAGS` (Standard `-d`) in [docker-compose.yml](docker-compose.yml) setzen oder via `docker run -e PRIME95_FLAGS="-t" ...` übergeben.
- Einstiegspunkt: [entrypoint.sh](entrypoint.sh) ruft `./mprime` im entpackten Verzeichnis auf.
# prime95-docker

Containerisiert Prime95. Beim Build wird automatisch der zweitneueste Major-Ordner aus https://download.mersenne.ca/gimps/ gewählt (z.B. v30), darin die neueste Version (z.B. 30.19) und daraus das neueste linux64-Tarball geladen und entpackt.

## Nutzung
- Build & Start: `docker compose up -d`
- Direkt mit `docker run`:
  ```bash
  docker run --name prime95 --restart no -e PRIME95_FLAGS="-d" -it ghcr.io/arthur2500/prime95:latest
  ```
  Mit Volumes:
  ```bash
  docker run --name prime95 --restart no -e PRIME95_FLAGS="-d -t" -it -v ./prime95/prime.txt:/opt/prime95/prime.txt -v ./prime95/results.txt:/opt/prime95/results.txt ghcr.io/arthur2500/prime95:latest
  ```
- Flags anpassen: `PRIME95_FLAGS` (Standard `-d -t`) in [docker-compose.yml](docker-compose.yml) setzen oder via `docker run -e PRIME95_FLAGS="-t" ...` übergeben.
- Einstiegspunkt: [entrypoint.sh](entrypoint.sh) ruft `./mprime` im entpackten Verzeichnis auf.
- Volumes: Optional können `prime.txt` sowie `results.txt` an den Host durchgereicht werden. Dazu muss mit `mkdir -p ./prime95 && touch ./prime95/prime.txt && touch ./prime95/results.txt` das Verzeichnis und die beinhalteten Dateien erstellt werden.

## Einstellungen
```PRIME95 COMMAND LINE ARGUMENTS
------------------------------

-t		Run the torture test.  Same as Options/Torture Test.
-Wdirectory	This tells prime95 to find all its files in a different
		directory than the executable.

MPRIME COMMAND LINE ARGUMENTS
----------------------------

-c		Contact the PrimeNet server then exit.  Useful for
		scheduling server communication as a cron job or
		as part of a script that dials an ISP.
-d		Prints more detailed information to stdout.  Normally
		mprime does not send any output to stdout.
-m		Bring up the menus to set mprime's preferences.
-t		Run the torture test.  Same as Options/Torture Test.
-v		Print the version number of mprime.
-Wdirectory	This tells mprime to find all its files in a different
		directory than the executable.```
# GWiki - a lightweight Git-backed wiki

Latest Linux build: [download gwiki](https://github.com/magomedcoder/gwiki/gwiki/releases/latest/download/gwiki).

```bash
chmod +x gwiki
```

## Server

```bash
./gwiki -data ./data -addr :8000 -pepper 'long-secret' -secure
```

| Flag      | Default     | Purpose                                                        |
|-----------|-------------|----------------------------------------------------------------|
| `-data`   | `./data`    | main storage                                                   |
| `-addr`   | `:8000`     | HTTP address                                                   |
| `-pepper` | empty       | password hash secret, same as for `user add` and `user passwd` |
| `-secure` | off         | secure cookie and strict transport header; requires HTTPS      |
| `-home`   | `README.md` | branch root page                                               |
| `-lang`   | `ru`        | default UI language (`ru`, `en`)                               |


## Users

Set the password with `-password`. If the flag is empty, it is read hidden from the terminal.

The first user becomes an administrator. `-admin` also makes later users administrators.

```bash
./gwiki user add -data ./data -email gwiki@example.com -name GWiki -surname GWiki -password 'S3cure-Wiki-Pass' -pepper 'long-secret' -admin

./gwiki user passwd -data ./data -email gwiki@example.com -password 'N3w-Wiki-Password' -pepper 'long-secret'

./gwiki user block -data ./data -email editor@example.com

./gwiki user unblock -data ./data -email editor@example.com

./gwiki user delete -data ./data -email editor@example.com
```

| Command        | Flags                                                              |
|----------------|--------------------------------------------------------------------|
| `user add`     | `-data` `-email` `-name` `-surname` `-password` `-pepper` `-admin` |
| `user passwd`  | `-data` `-email` `-password` `-pepper`                             |
| `user block`   | `-data` `-email`                                                   |
| `user unblock` | `-data` `-email`                                                   |
| `user delete`  | `-data` `-email`                                                   |

`-pepper` for `user add`, `user passwd`, and the server must match. Otherwise existing passwords will not work.

---

## Docker

```bash
docker build -t gwiki .
docker run -p 8000:8000 -v gwiki-data:/var/lib/data gwiki -pepper 'long-secret'
```

Data lives in the `gwiki-data` volume. First user:

```bash
docker run --rm -v gwiki-data:/var/lib/data gwiki user add -data ./data -email gwiki@example.com -name GWiki -surname GWiki -password 'S3cure-Wiki-Pass' -pepper 'long-secret' -admin
```

---

## Build from source

Requires Go 1.27, Node.js 22, and Yarn 1.22.

```bash
yarn
yarn build:css
go build -o build/gwiki ./cmd/gwiki
```

`yarn build:css` must run before `go build`

---

## Files and Git

Browse and edit files at `/files` (or `/b/{branch}/files`). Max file size 2 MiB.

Wiki branches are folders in the repo (`main/`, `docs/`, ...). Clone and push via `/git` with HTTP Basic (email and password):

```bash
git clone http://127.0.0.1:8000/git
cd git
git add -A && git commit -m "update"
git push origin HEAD
```

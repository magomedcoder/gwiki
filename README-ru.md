# GWiki - лёгкая система для ведения вики на базе Git

Последняя сборка для Linux: [скачать gwiki](https://github.com/gitwold/gwiki/releases/latest/download/gwiki).

```bash
chmod +x gwiki
```

## Сервер

```bash
./gwiki -data ./data -addr :8000 -pepper 'длинный-секрет' -secure
```

| Флаг      | По умолчанию | Назначение                                                      |
|-----------|--------------|-----------------------------------------------------------------|
| `-data`   | `./data`     | основное хранилище                                              |
| `-addr`   | `:8000`      | адрес HTTP                                                      |
| `-pepper` | пусто        | секрет хеша паролей, тот же, что при `user add` и `user passwd` |
| `-secure` | выключен     | защищённая кука и строгий заголовок транспорта, нужен HTTPS     |
| `-home`   | `README.md`  | страница корня ветки                                            |
| `-lang`   | `ru`         | язык интерфейса по умолчанию (`ru`, `en`)                       |


## Пользователи

Пароль задаётся флагом `-password`. Если флаг пустой, читает его скрыто из терминала.

Первый пользователь становится администратором. Флаг `-admin` делает администратором и следующих.

```bash
./gwiki user add -data ./data -email gwiki@example.com -name GWiki -surname GWiki -password 'S3cure-Wiki-Pass' -pepper 'длинный-секрет' -admin

./gwiki user passwd -data ./data -email gwiki@example.com -password 'N3w-Wiki-Password' -pepper 'длинный-секрет'

./gwiki user block -data ./data -email editor@example.com

./gwiki user unblock -data ./data -email editor@example.com

./gwiki user delete -data ./data -email editor@example.com
```

| Команда        | Флаги                                                              |
|----------------|--------------------------------------------------------------------|
| `user add`     | `-data` `-email` `-name` `-surname` `-password` `-pepper` `-admin` |
| `user passwd`  | `-data` `-email` `-password` `-pepper`                             |
| `user block`   | `-data` `-email`                                                   |
| `user unblock` | `-data` `-email`                                                   |
| `user delete`  | `-data` `-email`                                                   |

`-pepper` у `user add`, `user passwd` и у сервера должен совпадать. Иначе уже сохранённые пароли не подойдут.

---

## Docker

```bash
docker build -t gwiki .
docker run -p 8000:8000 -v gwiki-data:/var/lib/data gwiki -pepper 'длинный-секрет'
```

Данные в томе `gwiki-data`. Первый пользователь:

```bash
docker run --rm -v gwiki-data:/var/lib/data gwiki user add -data ./data -email gwiki@example.com -name GWiki -surname GWiki -password 'S3cure-Wiki-Pass' -pepper 'длинный-секрет' -admin
```

---

## Сборка из исходников

Нужны Go 1.27, Node.js 22 и Yarn 1.22.

```bash
yarn
yarn build:css
go build -o build/gwiki ./cmd/gwiki
```

`yarn build:css` нужен до `go build`

---

## Файлы и Git

Файлы - `/files` (или `/b/{branch}/files`). Лимит размера 2 МБ.

Ветки вики - папки в репозитории (`main/`, `docs/`, ...). Clone и push через `/git` с HTTP Basic (почта и пароль):

```bash
git clone http://127.0.0.1:8000/git
cd git
git add -A && git commit -m "правка"
git push origin HEAD
```

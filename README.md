### Статус тестов и линтера Hexlet

[![Actions Status](https://github.com/Absaidov/devops-engineer-from-scratch-project-315/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Absaidov/devops-engineer-from-scratch-project-315/actions)

## Доступ к приложению

Приложение доступно по следующим адресам:

- [http://uit14.ru](http://uit14.ru)
- [http://www.uit14.ru](http://www.uit14.ru)

## Развёртывание

Установите необходимые коллекции Ansible:

```bash
ansible-galaxy collection install -r requirements.yml
```

### Подготовка сервера

Перед первым развёртыванием приложения укажите адрес сервера и пользователя для
SSH-подключения в `inventory.ini`, а затем выполните:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

Подготовительный playbook:

- устанавливает Docker, Docker Compose, Git, cURL и UFW;
- запускает Docker и включает его автоматический запуск вместе с системой;
- добавляет SSH-пользователя в группу `docker`;
- открывает входящие TCP-порты `22`, `80` и `443`;
- запрещает остальные входящие подключения и разрешает исходящие;
- включает firewall UFW.

Подготовку достаточно выполнить один раз для каждого нового сервера. Повторный
запуск безопасен: Ansible применит только отсутствующие изменения.

### Деплой приложения

Разверните образ с тегом, указанным в `group_vars/app/vars.yml`:

```bash
make deploy
```

Чтобы развернуть новую версию, укажите полный SHA Git-коммита образа:

```bash
make deploy IMAGE_TAG=<full-commit-sha>
```

Чтобы откатиться к ранее развёрнутому образу, укажите SHA соответствующего
Git-коммита:

```bash
make rollback IMAGE_TAG=<previous-full-commit-sha>
```

Роль развёртывания не принимает изменяемые теги, например `latest`. Данные и
логи приложения хранятся на сервере в каталоге `/srv/project-devops-deploy` и
сохраняются при замене контейнера.

### Хранение изображений в Object Storage

Для приложения используется закрытый бакет Yandex Object Storage
`uit14-bulletins-images`. Бакет подготовлен вручную следующим образом:

1. В Object Storage создан бакет без публичного доступа.
2. Создан отдельный сервисный аккаунт `bulletins-s3`.
3. Сервисному аккаунту назначена роль `storage.uploader` только на этот бакет.
4. Для сервисного аккаунта создан статический ключ доступа.
5. Идентификатор и секретная часть ключа зашифрованы в Ansible Vault.

Публичные параметры подключения находятся в `group_vars/app/vars.yml`. В
зашифрованном `group_vars/app/vault.yml` должны находиться переменные
`vault_s3_access_key` и `vault_s3_secret_key`. Во время деплоя роль передаёт в
контейнер имя бакета, регион `ru-central1`, endpoint
`https://storage.yandexcloud.net` и ключи доступа. Бакет остаётся закрытым, а
приложение формирует временные подписанные ссылки для скачивания файлов.

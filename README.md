# Окружение рабочего стола

Набор скриптов для развёртывания привычной рабочей среды на Ubuntu.

## Полная установка

Если установлен `git`

```shell
git clone git@git.anthonyaxenov.ru:anthony/my-env.git --depth=1
cd my-env
sudo ./start.sh
```

Если не установлен `git`

```shell
wget -qO - http://git.anthonyaxenov.ru/anthony/my-env/archive/master.tar.gz | tar -zxf -
cd my-env
sudo ./start.sh
```

Скрипт `start.sh` обработает все `*.sh`-скрипты из [`/install`](/install) по порядку.

## Частичная установка

Без полного развёртывания репозитория

```shell
wget -qO - http://git.anthonyaxenov.ru/anthony/my-env/raw/branch/master/install/000-apt.sh | bash
```

После полного развёртывания репозитория (см. полную установку):

```shell
cd my-env
sudo ./install/000-apt.sh
```

## Тема оформления (только MATE)

Также можно установить визуальное оформление:
* тема: [Budgie Desktop Dark Theme](https://www.pling.com/p/1276879)
* икoнки: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/)
* курсоры: [Bridge](https://www.mate-look.org/s/Mate/p/999983/), [Capitaine Cursors](https://www.gnome-look.org/p/1148692/)

```shell
sudo ./theme/install.sh
```

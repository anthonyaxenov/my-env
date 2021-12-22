# Окружение рабочего стола

Установщик софта и визуала.
Используется для развёртывания привычной рабочей среды на Ubuntu.

Для установки всего софта выполнить команду:

```shell
sudo ./start.sh
```

Команда обработает все `*.sh`-скрипты из [`/install`](/install) по порядку.

Если весь софт не нужен, то следует обращаться к этим скриптам по отдельности:

```shell
./install/050-syncthing.sh
```

Также можно установить визуальное оформление (**только в среде MATE**):
* тема: [Budgie Desktop Dark Theme](https://www.pling.com/p/1276879)
* икoнки: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/)
* курсоры: [Bridge](https://www.mate-look.org/s/Mate/p/999983/), [Capitaine Cursors](https://www.gnome-look.org/p/1148692/)

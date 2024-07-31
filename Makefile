# Autogenerated at 01.08.2024 00:01 using ./gen-makefile
.DEFAULT_GOAL := help

#===============================================
#	Scripts listed in ./install
#===============================================

##apache2: Install apache2 (latest)
apache2:
	@./install/apache2

##apt: Install software from apt
apt:
	@./install/apt

##canon-mg2500: Install Canon Pixma MG2500 + ppa
canon-mg2500:
	@./install/canon-mg2500

##chrome: Install google chrome (latest)
chrome:
	@./install/chrome

##composer: Install composer (latest)
composer:
	@./install/composer

##docker: Install docker (latest) + docker-compose (latest) + ppa
docker:
	@./install/docker

##dots: Install dotfiles
dots:
	@./install/dots

##droidcam: Install droidcam v1.9.0
droidcam:
	@./install/droidcam

##droidcam-obs: Install droidcam-obs plugin v1.5.1
droidcam-obs:
	@./install/droidcam-obs

##flameshot: Install flameshot (latest)
flameshot:
	@./install/flameshot

##git: Install git (latest)
git:
	@./install/git

##golang: Install golang v1.21.0
golang:
	@./install/golang

##grub-customizer: Install grub-customizer (latest + ppa)
grub-customizer:
	@./install/grub-customizer

##jbmono: Install JetBrains Mono fonts
jbmono:
	@./install/jbmono

##kde-appmenu: Install KDE Window AppMenu Applet
kde-appmenu:
	@./install/kde-appmenu

##kde-backports: Install KDE Backports
kde-backports:
	@./install/kde-backports

##kde-file-templates: Install file templates (KDE)
kde-file-templates:
	@./install/kde-file-templates

##kde-portal: Install KDE portal
kde-portal:
	@./install/kde-portal

##libreoffice: Install libreoffice
libreoffice:
	@./install/libreoffice

##lite-xl: Install lite-xl
lite-xl:
	@./install/lite-xl

##mariadb: Install mariadb (latest) and php-mysql + phpMyAdmin (if php is installed)
mariadb:
	@./install/mariadb

##nodejs: Install nodejs + npm via nvm
nodejs:
	@./install/nodejs

##ntfy: Install ntfy (latest) + ppa
ntfy:
	@./install/ntfy

##obs-studio: Install obs-studio (latest snap)
obs-studio:
	@./install/obs-studio

##omz-clean: Install omz (latest)
omz-clean:
	@./install/omz-clean

##omz-fancy: Install omz fancy (powerline10k + MesloLGS font)
omz-fancy:
	@./install/omz-fancy

##openvpn: Install openvpn v2.6.3 (src)
openvpn:
	@./install/openvpn

##papirus: Install papirus-icon-theme (latest)
papirus:
	@./install/papirus

##pgsql: Install postgresql (latest) and php-pgsql (if php is installed)
pgsql:
	@./install/pgsql

##php: Install php v8.1 + ppa
php:
	@./install/php

##phpcs: Install phpcs + php-cs-fixer
phpcs:
	@./install/phpcs

##phpmd: Install phpmd
phpmd:
	@./install/phpmd

##php-psalm: Install psalm
php-psalm:
	@./install/php-psalm

##php-spx: Install php-spx
php-spx:
	@./install/php-spx

##phpstan: Install phpstan
phpstan:
	@./install/phpstan

##phpunit: Install phpunit
phpunit:
	@./install/phpunit

##postman: Install postman (latest)
postman:
	@./install/postman

##qt5: Install qt5
qt5:
	@./install/qt5

##rustdesk: Install rustdesk client v1.1.9 (deb)
rustdesk:
	@./install/rustdesk

##snap: Install bunch of software from snap
snap:
	@./install/snap

##sublimetext: Install Sublime Text (build 4169)
sublimetext:
	@./install/sublimetext

##syncthing: Install syncthing (latest) + ppa
syncthing:
	@./install/syncthing

##telebit: Install telebit (latest)
telebit:
	@./install/telebit

##telegram: Install telegram (latest)
telegram:
	@./install/telegram

##ulauncher: Install ulauncher (latest) + ppa
ulauncher:
	@./install/ulauncher

##vivaldi: Install Vivaldi + ppa
vivaldi:
	@./install/vivaldi

##wine: Install wine (latest) + ppa (focal)
wine:
	@./install/wine

##youtube-dl: Install youtube-dl (src)
youtube-dl:
	@./install/youtube-dl

##ytdlcue: Install ytdlcue
ytdlcue:
	@./install/ytdlcue

##zint: Install zint (latest)
zint:
	@./install/zint

##zsh: Install vanilla zsh
zsh:
	@./install/zsh


#===============================================
#	Scripts listed in ./packs
#===============================================

##flameshot: [TODO] [PACK] qt5 + flameshot from source
flameshot: qt5 flameshot-build

##lamp: [PACK] Apache + php + mariadb
lamp: apache phpstack mariadb

##obs: [PACK] Install OBS Studio + droidcam-obs
obs: obs-studio droidcam-obs

##omz: [PACK] zsh + omz + powerline10k + MesloLGS font
omz: zsh omz-clean omz-fancy
	chsh -s /usr/bin/zsh
	@exec zsh

##phptools: [PACK] Install only php tooling (composer, phpunit, psalm, phpcs, php-cs-fixer, php-spx, phpmd)
phptools: composer php-psalm php-spx phpcs phpmd phpstan phpunit

##phpstack: [PACK] Install full php stack with tooling
phpstack: php phptools

#===============================================
#	Scripts listed in ./upgrade
#===============================================

##^omz: Upgrade omz
^omz:
	@./upgrade/omz

#===============================================
#	Scripts listed in ./uninstall
#===============================================

##/apache2: Uninstall apache2
/apache2:
	@./uninstall/apache2

##/docker: Uninstall docker + ppa
/docker:
	@./uninstall/docker

##/grub-customizer: Uninstall grub-customizer with ppa
/grub-customizer:
	@./uninstall/grub-customizer

##/lite-xl: Uninstall lite-xl
/lite-xl:
	@./uninstall/lite-xl

##/omz: Uninstall omz
/omz:
	@./uninstall/omz

##/vivaldi: Uninstall vivaldi + ppa
/vivaldi:
	@./uninstall/vivaldi

#===============================================
#	Service goals
#===============================================

self:
	@./gen-makefile
help: Makefile
	@echo "Ubuntu software installator"
	@echo
	@echo "Usage:"
	@echo "\tmake  help\t - show this help"
	@echo "\tmake  self\t - regenerate Makefile (alias of ./gen-makefile)"
	@echo "\tmake  GOAL\t - install software"
	@echo "\tmake ^GOAL\t - upgrade software"
	@echo "\tmake /GOAL\t - uninstall software"
	@echo "\nYou can combine GOALs, here are some examples:"
	@echo "\tmake /docker docker"
	@echo "\tmake php /docker ^omz"
	@echo "\nAvailable GOALs:"
	@sed -n 's/^##//p' $< | column -ts ':' | sed -e "s/^/\t/"
+%:
	@make 

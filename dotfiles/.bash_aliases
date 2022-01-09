# Common
own() {
    sudo chmod 0664 -R --preserve-root $@
    sudo chown $USER. -R --preserve-root $@
}
#alias aliases='source ~/install/aliases && cat ~/install/aliases'
alias aliases='source ~/install/aliases'
alias zshrc='source ~/.zshrc'
alias wine='LANG=ru_RU.utf8 wine'
alias upgrade='sudo apt update && sudo apt upgrade -y'
alias duh='du -ha --max-depth=1'
alias sduh='sudo du -ha --max-depth=1'
alias ports='netstat -tulanp'

# Navigation
alias projects='cd ~/projects'
alias Downloads='cd ~/Downloads'

# apache2
alias a2ls='ls -al /etc/apache2/sites-available/'
alias a2slen='ls -al /etc/apache2/sites-enabled/'
alias a2err='sudo tail /var/log/apache2/error_log'
#alias a2errclr='sudo truncate -s0 "/var/log/apache2/error_log"'
alias a2restart='sudo systemctl restart apache2'
alias a2reload='sudo systemctl reload apache2'

# nginx
#alias nxls='ls -al /etc/nginx/sites-available/'
#alias nxlsen='ls -al /etc/nginx/sites-enabled/'
#alias nxerr='sudo tail /var/log/nginx/error.log'
#alias nxerrclr='sudo truncate -s0 "/var/log/nginx/error.log"'
#alias nxrest='sudo systemctl restart nginx'
#alias nxreload='sudo systemctl reload nginx'
#alias nxensite='~/Scripts/web/nxensite.sh'

# mysql
alias mysqlstart='sudo systemctl start mysql'
alias mysqlstop='sudo systemctl stop mysql'
alias mysqlrestart='sudo systemctl restart mysql'
alias mysqlstatus='sudo systemctl status mysql'

# pgsql
#alias psql='sudo -u postgres psql'

# php
alias phprestart='sudo systemctl restart php-fpm'

# Docker
alias dockerstart='sudo systemctl start docker'
alias dockerrestart='sudo systemctl restart docker'
alias dockerstop='sudo systemctl stop docker'

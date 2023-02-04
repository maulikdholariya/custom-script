clear-ram(){
    sudo sh -c 'echo 1 >  /proc/sys/vm/drop_caches';
    sudo sh -c 'echo 2 >  /proc/sys/vm/drop_caches';
    sudo sh -c 'echo 3 >  /proc/sys/vm/drop_caches';
    echo "clear";
}

ssh-technource(){
    ssh-agent bash;
    ssh-add /home/technource/.ssh/id_hommati;
    echo "ssh-technource run"
}

set-php(){
    sudo update-alternatives --set php /usr/bin/php$1;
    sudo update-alternatives --set phar /usr/bin/phar$1;
    sudo update-alternatives --set phar.phar /usr/bin/phar.phar$1;
}

all-pull(){
  ls | xargs -P10 -I{} git -C {} pull
}

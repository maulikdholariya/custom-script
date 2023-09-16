clear-ram(){
    sudo sh -c 'echo 1 >  /proc/sys/vm/drop_caches';
    sudo sh -c 'echo 2 >  /proc/sys/vm/drop_caches';
    sudo sh -c 'echo 3 >  /proc/sys/vm/drop_caches';
    echo "clear";
}

ssh-test(){
    ssh-agent bash;
    ssh-add /home/test/.ssh/id;
    echo "ssh-test run"
}

set-php(){
    sudo update-alternatives --set php /usr/bin/php$1;
    sudo update-alternatives --set phar /usr/bin/phar$1;
    sudo update-alternatives --set phar.phar /usr/bin/phar.phar$1;
}

all-pull(){
  ls | xargs -P10 -I{} git -C {} pull --all
}

get-all(){
    git branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
    git pull --all
}
delete-all(){
    #git branch | grep -v "master" | xargs git branch -d
    git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d
}
get-count(){
    echo "branch-remote-count"
    git branch -r | wc -l
    echo "branch-local-count"
    git branch | wc -l
}
alias tmux='tmux -u'

#!/bin/bash
clear-ram(){
    sudo sh -c 'echo 1 >  /proc/sys/vm/drop_caches';
    sudo sh -c 'echo 2 >  /proc/sys/vm/drop_caches';
    sudo sh -c 'echo 3 >  /proc/sys/vm/drop_caches';
    echo "clear";
}

set-php(){
    sudo update-alternatives --set php /usr/bin/php$1;
    sudo update-alternatives --set phar /usr/bin/phar$1;
    sudo update-alternatives --set phar.phar /usr/bin/phar.phar$1;
}

all-pull(){
    # ls | xargs -P10 -I{} git -C {} pull --all 
    # ls | xargs -I{} sh -c 'echo "Fetching updates for repository: {}"; git -C {} pull --all'
    # ls | xargs -P10 -I{} sh -c 'echo "Pulling changes in {}"; git -C {} pull --all'
    # ls -d */ | xargs -P10 -I{} sh -c 'echo "Updating repository: {}" && git -C {} pull --all'

    for dir in */; do
        # echo "Fetching updates for repository" $dir
        current_branch=$(git -C "$dir" branch --show-current)
        echo "Current branch in $dir repository is: $current_branch"
        # git -C "$dir" branch --show-current
        git -C "$dir" pull --all
    done
 
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


all-pulls(){
    parallel -j10 --line-buffer 'current_branch=$(git -C {} branch --show-current); echo "Current branch in {} repository is: $current_branch"; git -C {} pull --all' ::: */
}
all-pull-v1(){
    ls | xargs -P10 -I{} git -C {} pull --all 
}

load-ssh(){
     ssh-agent bash;
    for possiblekey in ${HOME}/.ssh/*; do
        if grep -q PRIVATE "$possiblekey"; then
            echo "$possiblekey"
            ssh-add "$possiblekey"
        # else
            # echo "$possiblekey not added"
        fi
    done
}
check_git_user() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    # If inside a Git repository, display the Git username
    echo "Git Username: $(git config user.name)"
    echo "Git Email: $(git config user.email)"
  fi
}
cd() {
  builtin cd "$@" && \
  if [ -f .nvmrc ]; then
    CURRENT_VERSION=$(nvm current)
    nvm use > /dev/null 2>&1
    NEW_VERSION=$(nvm current)
    if [ "$CURRENT_VERSION" != "$NEW_VERSION" ]; then
      echo "Now using node $(nvm current)"
    fi
  else
    nvm use default > /dev/null 2>&1
  fi
  check_git_user
}
db(){
for file in  ${HOME}/sql/*.sql; do
    mysql -u root -proot gamechanger < "$file"
done
}

reset-2-trial(){
#WebStorm DataGrip PhpStorm CLion PyCharm GoLand RubyMine
    for product in IntelliJIdea PhpStorm; do
        echo "[+] Resetting trial period for $product"

        echo "[+] Removing Evaluation Key..."
        rm -rf ~/.config/$product*/eval 2> /dev/null

        # Above path not working on latest version, Fixed below
        rm -rf ~/.config/JetBrains/$product*/eval 2> /dev/null

        echo "[+] Removing all evlsprt properties in options.xml..."
        sed -i 's/evlsprt//' ~/.config/$product*/options/other.xml 2> /dev/null

        # Above path not working on latest version, Fixed below
        sed -i 's/evlsprt//' ~/.config/JetBrains/$product*/options/other.xml 2> /dev/null

        echo
    done

    echo "Removing userPrefs files..."
    rm -rf ~/.java/.userPrefs 2> /dev/null
}



#load-ssh
    
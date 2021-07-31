#!/bin/bash

# Import title
. title.sh

# Import list functionality
. item_list.sh

# Import git providers
. git_providers.sh


if [[ $1 == "-h" || $1 == "--help" || -z $1 ]]; then
    echo "USAGE: omnigit [DIRECTORY]"
    echo -e "Backup some repositories in a different git provider\n"
    echo "First argument -> Absolute path of the directory in which to look for git repositories"
    exit
fi


# SELECT GIT PROVIDERS
clear
providers_title() {
    print_title
    echo "Menu providers"
}
select_items providers_title providers providers_choices

# SELECT REPOSITORIES TO BACKUP
REPOSITORIES_PATH=$1
for repository_path in $(find $REPOSITORIES_PATH -name .git -type d -prune); do
    repositories_paths+=("${repository_path}")
    repositories+=($(awk '{n = split($0, tokens, "/"); print tokens[n - 1]}' <<< "$repository_path"))
done

clear
repositories_title() {
    print_title
    echo "Menu repositories"
}
select_items repositories_title repositories repositories_choices

# SHOW CONFIGURATION AND ASK CONFIRMATION
echo -e "Configuration\n"
print_selected_items "providers" providers providers_choices
echo ""
print_selected_items "repositories" repositories repositories_choices

echo -e "\nWant to proceed?"
echo "  y -> yes"
echo "  n -> no"
read -n 1 key
while [[ $key != 'y' ]]; do
    case "$key" in
        'n') exit 1;;
    esac
    clear
done
echo -e "\n\n"

# BACKUP REPOSITORIES
for i in ${!repositories_choices[@]}; do
    if selected_item repositories_choices $i; then
        for j in ${!providers_choices[@]}; do
            if selected_item providers_choices $j; then
	        echo "Backing up ${repositories[i]}..."
		cd ${repositories_paths[i]}
	        remote="git@${providers_url[j]}:danielorihuela/${repositories[i]}.git"
		if !(git remote -v | grep origin); then
		    git remote add origin $remote
		    git push --all
		fi
	        if !(git remote -v | grep $remote); then
                    git remote set-url origin --add $remote
	            git push --all
	        fi
	    fi
	done
    fi
done

#!bin/env bash
# Automate Server Deployment with Git Bare Repository

# Function to check if a directory exists
check_directory() {
    if [ -d "$1" ]; then
        echo " --- Directory '$1' already exists."
    else
        echo " --- Directory '$1' does not exist. Creating..."
        mkdir -p "$1"
        echo " --- Directory '$1' created."
    fi
}

# Function to extract IP address from a string using grep
extract_ip_grep() {
    local input="$1"
    local ip_address=$(echo "$input" | grep -E -o '([0-9]{1,3}\.){3}[0-9]{1,3}')
    echo "$ip_address"
}


echo -e "\n\tWelcome To Git Bare Auto"
echo -e "\n>> Repository Name:"
read repoName

echo -e "\n>> Project Path:"
read projectPath
echo "\n"

echo " --- Creating repository $repoName at $projectPath"

check_directory $projectPath

# Creating Bare repo and Initialize
cd $projectPath
git init --bare  $repoName.git

text="git --work-tree=$projectPath/$repoName --git-dir=$projectPath/$repoName.git checkout -f main"
postHookPath="$projectPath/$repoName.git/hooks/post-receive"
workTreePath="$projectPath/$repoName"
echo " --- Creating Work Tree at $workTreePath"
check_directory $workTreePath
echo " --- Creating post-receive hook | Directory: $postHookPath"
echo "$text" > "$postHookPath"

chmod +x "$postHookPath"

# creating remote path
currentUser=$(whoami)
echo "Add Remote Command Template:"
echo "git remote add live $currentUser@<ip_address>:$projectPath/$repoName.git"
echo "git push --set-upstream live main"
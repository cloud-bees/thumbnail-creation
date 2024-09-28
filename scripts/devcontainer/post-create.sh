#!/bin/zsh

cat <<EOF >> ~/.zshrc

git() {
  if [[ \$# -ge 1 && "\$1" == "status" ]]; then
    echo "========= Run git stash list ========="
    var=\$(git stash list 2>&1)
    echo -e "\033[35m \$var \e[0m"
    echo "========= End git stash list ========="
    command git status
  else
    command git "\$@"
  fi
}

alias gps='git push origin HEAD'
alias gpl='git pull origin \$(git rev-parse --abbrev-ref HEAD)'

EOF

# Fix issue env variables reference to other env variables are set after the container is created
if [ ! -f "$PWD/$env_file" ]; then
  exit 1
fi
grep '\$' "$PWD/$env_file" | while IFS= read -r line; do
  echo "export $line" >> ~/.zshrc
done

# Install git lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo zsh
sudo apt-get install git-lfs -y
git lfs install

# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.55.0

# Setup pre-commit
pip install pre-commit
pre-commit install --hook-type commit-msg

if [ -x "$(command -v terraform --version)" ]; then
  terraform -install-autocomplete
fi
#!/bin/bash 

cat << EOF
Terraform development environment setup

This script automates the installation and configuration of essential tools for Terraform development.
It was crafted for Ubuntu 24.04.1 LTS on x86_64 architecture. May work on other Debian-based systems.
For other Linux distros and architectures, some tweaks are necessary.
The installation of the Terraform extension in VSCode is manual.

EOF

sudo apt-get install curl -y > /dev/null 2>&1

echo -e "\nInstalling vscode..."

curl -L -o vscode.deb  https://go.microsoft.com/fwlink/?LinkID=760868 > /dev/null 2>&1

sudo DEBIAN_FRONTEND=noninteractive apt-get -y install ./vscode.deb > /dev/null 2>&1

code --version

echo -e "\nManually launch VSCode and use Quick Open (Ctrl+P), paste the command "ext install HashiCorp.terraform"\n and press enter to install the extension @id:HashiCorp.terraform"

echo -e "\nInstalling tvenv..."

export TENV_LATEST=$(curl -s https://api.github.com/repos/tofuutils/tenv/releases/latest | jq -r '.assets[] | select(.name | endswith("Linux_x86_64.tar.gz")) | .browser_download_url')

curl -L -O $TENV_LATEST > /dev/null 2>&1

mkdir ~/.tenv

tar xzf $(echo $TENV_LATEST | grep -o -E "tenv_v.*") -C ~/.tenv

export PATH="$HOME/.tenv:$PATH"

tenv completion bash > ~/.tenv/tenv_completion.bash

echo -e '\n# tenv and terraform tools\nexport PATH="$HOME/.tenv:$PATH"\nsource $HOME/.tenv/tenv_completion.bash' >> ~/.bashrc

tenv version

echo -e "\nInstalling Terraform CLI..."

tenv terraform install > /dev/null 2>&1

terraform -install-autocomplete

terraform version

echo -e "\nInstalling terraform-docs..."

export TDOC_LATEST=$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | jq -r '.assets[] | select(.name | endswith("linux-amd64.tar.gz")) | .browser_download_url')

curl -L -O $TDOC_LATEST > /dev/null 2>&1

tar xzf $(echo $TDOC_LATEST | grep -o -E "terraform-docs-.+") -C ~/.tenv terraform-docs

terraform-docs completion bash > ~/.tenv/terraform-docs_completion.bash

echo -e '\nsource $HOME/.tenv/terraform-docs_completion.bash' >> ~/.bashrc

terraform-docs version

echo -e "\nInstalling TFLint..."

export TFLINT_LATEST=$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | jq -r '.assets[] | select(.name | endswith("tflint_linux_amd64.zip")) | .browser_download_url')

curl -L -O $TFLINT_LATEST > /dev/null 2>&1

unzip -o $(echo $TFLINT_LATEST | grep -o -E "tflint_linux.+") -d ~/.tenv > /dev/null 2>&1

tflint --version

echo -e "\nInstalling Trivy..."

export TRIVY_LATEST=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | jq -r '.assets[] | select(.name | endswith("Linux-64bit.tar.gz")) | .browser_download_url')

curl -L -O $TRIVY_LATEST > /dev/null 2>&1

tar xzf $(echo $TRIVY_LATEST | grep -o -E "trivy_.+") -C ~/.tenv trivy

trivy --version

echo -e "\nInstalling Checkov..."

# We are going to install checkov using python Pip and Venv
sudo apt install python3-pip python3.12-venv -y > /dev/null 2>&1

python3 -m venv ~/.venv

source ~/.venv/bin/activate

pip install checkov > /dev/null 2>&1

checkov --version

echo -e "\nInstalling pre-commit..."

pip install pre-commit > /dev/null 2>&1

pre-commit --version

rm $(echo $TENV_LATEST | grep -o -E "tenv_v.*")

rm $(echo $TDOC_LATEST | grep -o -E "terraform-docs-.+")

rm $(echo $TFLINT_LATEST | grep -o -E "tflint_linux.+")

rm $(echo $TRIVY_LATEST | grep -o -E "trivy_.+")

rm ./vscode.deb

echo -e "\n...finished."
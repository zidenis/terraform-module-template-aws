# terraform-module-template-aws:ubuntu-24.04
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Install Python and other packages prerequisites
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y upgrade \ 
    && apt-get -y install --no-install-recommends python3-pip python3-venv jq unzip curl inotify-tools \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

USER vscode
ENV HOME="/home/vscode"
RUN mkdir ${HOME}/workspace

# Setup Python venv for Checkov and pre-commit
RUN python3 -m venv ${HOME}/.venv \
    && ${HOME}/.venv/bin/pip install --no-cache-dir checkov pre-commit
ENV PATH="${HOME}/.venv/bin:${PATH}"

# Install tenv, terraform-docs, tflint, trivy
# tenv
RUN mkdir -p ${HOME}/.tenv
RUN export TENV_LATEST=$(curl -s https://api.github.com/repos/tofuutils/tenv/releases/latest | jq -r '.assets[] | select(.name | endswith("Linux_x86_64.tar.gz")) | .browser_download_url') \
    && curl -L -o ${HOME}/tenv.tar.gz $TENV_LATEST \
    && tar xzf ${HOME}/tenv.tar.gz -C ${HOME}/.tenv \
    && rm ${HOME}/tenv.tar.gz
# terraform-docs
RUN export TDOC_LATEST=$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | jq -r '.assets[] | select(.name | endswith("linux-amd64.tar.gz")) | .browser_download_url') \
    && curl -L -o ${HOME}/tdocs.tar.gz $TDOC_LATEST \
    && tar xzf ${HOME}/tdocs.tar.gz -C ${HOME}/.tenv terraform-docs \
    && rm ${HOME}/tdocs.tar.gz
# tflint
RUN export TFLINT_LATEST=$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | jq -r '.assets[] | select(.name | endswith("tflint_linux_amd64.zip")) | .browser_download_url') \
    && curl -L -o ${HOME}/tflint.zip $TFLINT_LATEST \
    && unzip -o ${HOME}/tflint.zip -d ${HOME}/.tenv \
    && rm ${HOME}/tflint.zip
# trivy
RUN export TRIVY_LATEST=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | jq -r '.assets[] | select(.name | endswith("Linux-64bit.tar.gz")) | .browser_download_url') \
    && curl -L -o ${HOME}/trivy.tar.gz $TRIVY_LATEST \
    && tar xzf ${HOME}/trivy.tar.gz -C ${HOME}/.tenv trivy \
    && rm ${HOME}/trivy.tar.gz

ENV PATH="${HOME}/.tenv:${PATH}"

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${HOME}/awscliv2.zip" \
    && unzip "${HOME}/awscliv2.zip" -d "${HOME}/awscli" \
    && ${HOME}/awscli/aws/install -i ${HOME}/awscli -b ${HOME}/awscli/bin \
    && rm -rf ${HOME}/awscliv2.zip ${HOME}/awscli/aws
ENV PATH="${HOME}/awscli/bin:${PATH}"

# Generate bash completions
RUN tenv completion bash > ${HOME}/.tenv/tenv_completion.bash \
    && terraform-docs completion bash > ${HOME}/.tenv/terraform-docs_completion.bash \
    && echo 'source ~/.tenv/tenv_completion.bash' >> ~/.bashrc \
    && echo 'source ~/.tenv/terraform-docs_completion.bash' >> ~/.bashrc \
    && echo 'complete -C "/home/vscode/awscli/bin/aws_completer" aws' >> ~/.bashrc

# Directories synchronization
COPY --chown=vscode:vscode --chmod=u+x sync-dirs.sh ${HOME}/sync-dirs.sh


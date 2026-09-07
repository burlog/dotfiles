# aliases
alias ebp=/home/burlog/git/email/util/src/email-buildpackage
alias xmlrpc-netcat="xmlrpc-netcat3"
podinfo() { curl -s "py-rendertron.email.dev.dszn.cz/pod/ip-to-name/$1" | jq ; }

# I want cores
ulimit -c unlimited

# color codes explained: https://en.wikipedia.org/wiki/ANSI_escape_code
export GREP_COLORS='ms=01;33:mc=01;31:sl=32:cx=:fn=01;30:ln=36:se='
export GCC_COLORS="error=1;38;5;124:warning=1;38;5;202:note=38;5;34:locus=48;5;22;38;5;0:quote=38;5;33"

# exported variables
export PKG_CONFIG_PATH=/usr/lib64/pkgconfig/:/usr/local/lib64/pkgconfig:/usr/local/lib64/pkgconfig.szn/:/usr/local/share/pkgconfig/
export LOG_MASK=A
export LOG_STDERR=1
export SZN_LOCALITY=go

# android sdk
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator"

# pyenv initialization
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# loki env variables
source /home/burlog/.loki.env

# gitlab token
export GITLAB_TOKEN=$(cat /home/burlog/.tokens/gitlab)
# export GITHUB_TOKEN=$(cat /home/burlog/.tokens/github)
export SOURCEGRAPH_TOKEN=$(cat /home/burlog/.tokens/sourcegraph)
# ffq certs
export GFFQ_MDC_CERT=/home/burlog/.cert/esaas-mdc-certs/esaas-rw-email-antispam-prod-mdc.crt
export GFFQ_MDC_KEY=/home/burlog/.cert/esaas-mdc-certs/esaas-rw-email-antispam-prod-mdc.key
export GFFQ_DEV_CERT=/home/burlog/.cert/esaas-mdc-certs/esaas-rw-email-antispam-prod-mdc.crt
export GFFQ_DEV_KEY=/home/burlog/.cert/esaas-mdc-certs/esaas-rw-email-antispam-prod-mdc.key
export GFFQ_SASANKA_TOKEN=$(cat /home/burlog/.tokens/sasanka)
# email token
export EMAIL_TOKEN=$(cat /home/burlog/.tokens/email)
export EMAIL_DEV_TOKEN=$(cat /home/burlog/.tokens/email-dev)
# defefct dojo token
export DEFECT_DOJO_TOKEN=$(cat /home/burlog/.tokens/defectdojo)
# smtp password
export SMTP_PASSWORD=$(cat /home/burlog/.tokens/smtp-password)
# myvw password
export VW_PASSWORD=$(cat /home/burlog/.tokens/myvw-password)
export VW_EMAIL="burlog@seznam.cz"
# android key-store-password
export ANDROID_KEYSTORE_PASSWORD=$(cat /home/burlog/.tokens/android-keystore-password)
# grafana credentials
export GRAFANA_USERNAME=michal.bukovsky
export GRAFANA_PASSWORD=$(cat /home/burlog/.tokens/grafana-password)

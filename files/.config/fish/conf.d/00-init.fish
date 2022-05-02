set -gx PATH ~/.pyenv/bin ~/bin ~/dotfiles/bin ~/src/go/bin ~/.local/bin ~/.krew/bin $PATH ~/.cicd/bin

set -gx KUBECONFIG ~/.kube/config

set budspencer_colors 000000 333333 666666 ffffff ffff00 ff6600 ff0000 ff0033 3300ff 0000ff 00ffff 00ff00
set -U budspencer_nogreeting
set -U budspencer_nobell
set -xg PIPENV_VENV_IN_PROJECT 1

# Set PAR options
# set -xg PARINIT 'rTbgqR B=.,?_A_a Q=_s>|'

status is-login; and pyenv init --path | source
pyenv init - | source
status --is-interactive; and pyenv virtualenv-init - | source

# AWS 
set -xg AWS_DEFAULT_REGION us-west-2
set -xg AWS_ROLE_SESSION_NAME coldham@vmware.com

alias kc=kubectl


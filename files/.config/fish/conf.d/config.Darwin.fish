
if test "Darwin" = (uname)

    set -gx PATH ~/.fly/bin /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin ~/node_modules/.bin /Applications/Postgres.app/Contents/Versions/12/bin $PATH


#set -gx EDITOR code -w
    set -x GOPATH ~/src/go
# Added by Krypton
#gpgconf --launch gpg-agent
#set -x GPG_TTY (tty)
# Set this back if I ever decide to use the gpg agent for ssh as well.
#set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
#set -x GPG_AGENT_INFO (gpgconf --list-dirs agent-socket):(pgrep gpg-agent):1

# set -gx ERL_ROOTDIR ~/.erlangInstaller/24.0/erlang
# status --is-interactive; and source (rbenv init - | psub)
    source ~/.asdf/asdf.fish

    set -gx PATH ~/Library/Python/3.10/bin $PATH
#starship init fish | source
end

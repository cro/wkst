set -gx EDITOR code -w

if status --is-interactive and ! which keychain > /dev/null
  keychain --eval --quiet --inherit any -Q id_rsa id_ed25519 | source
end

if status --is-login
    set PPID (ps --ppid %self -o ppid | tail -1 | xargs)
    if ps -p $PPID | grep ssh > /dev/null
        if tmux has-session > /dev/null 2>&1
          tmux attach; and exec true
        else
          tmux; and exec true
        end
        echo "tmux failed to start; using plain fish shell"
    end
end
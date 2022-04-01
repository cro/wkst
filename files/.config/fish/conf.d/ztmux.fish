if status --is-login
  if test (uname) = "Darwin"; or test (uname) = "Linux"
    set PPID (ps -p %self -o ppid | tail -1 | xargs)
    if not test (ps -p $PPID | grep ssh > /dev/null); and not set -q ZELLIJ
      if test (zellij list-sessions > /dev/null 2>&1)
        zellij attach; and exec true
      else
        zellij; and exec true
      end
      echo "zellij failed to start; using plain fish shell"
    end
  end
end

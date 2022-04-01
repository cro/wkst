if status --is-login
  if test (uname) = "Darwin"; or test (uname) = "FreeBSD"
    set PPID (ps -p %self -o ppid | tail -1 | xargs)
    if ps -p $PPID | grep ssh > /dev/null
      if tmux has-session > /dev/null 2>&1
        tmux attach; and exec true
      else
        tmux; and exec true
      end
      echo "tmux failed to start; using plain fish shell"
    end
  end
end

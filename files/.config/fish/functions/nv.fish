
function nv --description "Neovim QT Start"
  set -xg NVIM_LISTEN_ADDRESS /tmp/nvimsocket

  ps guax | grep -i fvim | grep -v grep > /dev/null
  if test "$status" = "0"
      ~/.pyenv/versions/neovim/bin/nvr $argv
  else
      set -xg LUNARVIM_CONFIG_DIR ~/.config/lvim
      set -xg LUNARVIM_RUNTIME_DIR ~/.local/share/lunarvim
      set -xg LUNARVIM_CACHE_DIR "~/.cache/nvim"
      fvim -u "$LUNARVIM_RUNTIME_DIR/lvim/init.lua" $argv  > /tmp/neovim.log 2>&1 &
  end
end

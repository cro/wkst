if test "Linux" = (uname)

  set -gx EDITOR lvim

  if status --is-interactive and ! which keychain > /dev/null
    keychain --eval --quiet --inherit any -Q id_rsa id_ed25519 | source
  end

end

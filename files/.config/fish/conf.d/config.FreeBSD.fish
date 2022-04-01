set -gx EDITOR code -w

if test "FreeBSD" = (uname)

  if status --is-interactive and ! which keychain > /dev/null
    keychain --eval --quiet --inherit any -Q id_rsa id_ed25519 | source
  end

end

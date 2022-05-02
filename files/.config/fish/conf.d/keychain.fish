if status is-login
    keychain --quiet id_ed25519 
end

if test -f ~/.keychain/(hostname)-gpg-fish
    source ~/.keychain/(hostname)-gpg-fish
end

if test -f ~/.keychain/(hostname)-fish
    source ~/.keychain/(hostname)-fish
end

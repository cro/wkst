function rk -d 'Run rocker from anywhere'
    pushd ~/src/raasdev/rocker
    ./rk $argv
    popd
end

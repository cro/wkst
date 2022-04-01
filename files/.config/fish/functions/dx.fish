function dx -d 'Alias for docker exec -ti' 
    if test -z "$argv[2]"
        docker exec -ti $argv[1] /bin/bash
    else
        docker exec -ti $argv
    end
end

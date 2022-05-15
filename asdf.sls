git config --global --add safe.directory /home/cro/.asdf:
  cmd.run

Checkout asdf:
  git.latest:
    - name: https://github.com/asdf-vm/asdf.git
    - target: /home/cro/.asdf
    - rev: release-v0.10.1
    - user: cro

/home/cro/.config/fish/completions:
  file.directory:
    - user: cro
    - group: cro
    - mode: "0755"
    - makedirs: True

/home/cro/.config/fish/completions/asdf.fish:
  file.symlink:
    - target: /home/cro/.asdf/completions/asdf.fish

/home/cro/.config/fish/conf.d/asdf.fish:
  file.managed:
    - user: cro
    - group: cro
    - mode: "0644"
    - contents:
      -  source ~/.asdf/asdf.fish

Dev Packages:                                                                                                                                          
  pkg.installed:                                                                                                                                       
    - pkgs:                                                                                                                                            
      - build-essential                                                                                                                                
      - libncurses-dev                                                                                                                                 
      - sed                                                                                                                                            
      - git                                                                                                                                            
      - tar                                                                                                                                            
      - make                                                                                                                                           
      - gcc                                                                                                                                            
      - perl                                                                                                                                           
      - openssl                                                                                                                                        
      - flex                                                                                                                                           
      - bison                                                                                                                                          
      - default-jdk                                                                                                                                    
      - libssl-dev                                                                                                                                     
      - unixodbc-dev                                                                                                                                   
      - libwxgtk3.0-gtk3-dev                                                                                                                           
      - libwxgtk-webview3.0-gtk3-dev                                                                                                                   
      - libglu1-mesa-dev                                                                                                                               
      - fop                                                                                                                                            
      - xsltproc                                                                                                                                       
      - libxml2-utils                                                                                                                                  
      - g++

/home/cro/.asdf/bin/asdf plugin-add erlang:
  cmd.run:
    - runas: cro
    - cwd: /home/cro
    - creates: /home/cro/.asdf/plugins/erlang/bin/install

/home/cro/.asdf/bin/asdf plugin-add elixir:
  cmd.run:
    - runas: cro
    - cwd: /home/cro
    - creates: /home/cro/.asdf/plugins/elixir/bin/install

/home/cro/.asdf/bin/asdf plugin update --all:
  cmd.run:
    - runas: cro
    - cwd: /home/cro

/home/cro/.asdf/bin/asdf install erlang latest:
  cmd.run:
    - runas: cro
    - cwd: /home/cro

/home/cro/.asdf/bin/asdf install elixir latest:
  cmd.run:
    - runas: cro
    - cwd: /home/cro

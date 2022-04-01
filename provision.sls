Update Packages:
  pkg.uptodate:
    - refresh: True

Wanted Packages:
  pkg.installed:
    - pkgs:
        - wget
        - neovim
        - fish
        - npm
        - gcc-c++
        - ripgrep
        - fd-find
        - python3-neovim
        - dnf-plugins-core

dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo:
  cmd.run:
    - creates: /etc/yum.repos.d/docker-ce.repo 

Docker:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io

docker:
  service.running:
    - enable: True

curl https://pyenv.run | bash:
  cmd.run:
    - creates: /home/cro/.pyenv

Development Tools:
  pkg.group_installed

Development Libraries:
  pkg.group_installed

yarn:
  npm.installed

pnpm:
  npm.installed 

neovim-npm:
  npm.installed:
    - name: neovim

cro:
  user.present:
    - fullname: C. R. Oldham
    - home: /home/cro
    - shell: /usr/bin/fish
    - groups:
      - wheel
      - docker
    - password: "$6$qRKV9JUz4T7wyWFF$AsI2pgBqs9VOi8DkPKeqi3MIIIVtoxPvn7SnHpVa6f28vk2ZUsNjrmVO.zM1kYO1.x9Cc5dEK/K22YOimvg9r."

AAAAC3NzaC1lZDI1NTE5AAAAIL76QsHXnukwYpj1PcuLUW/detxKMs3ScBGt8kiDP7pi:
  ssh_auth.present:
    - user: cro
    - enc: ssh-ed25519

root:
  user.present:
    - password: "$6$qRKV9JUz4T7wyWFF$AsI2pgBqs9VOi8DkPKeqi3MIIIVtoxPvn7SnHpVa6f28vk2ZUsNjrmVO.zM1kYO1.x9Cc5dEK/K22YOimvg9r."

root-ssh-key:
  ssh_auth.present:
    - name: AAAAC3NzaC1lZDI1NTE5AAAAIL76QsHXnukwYpj1PcuLUW/detxKMs3ScBGt8kiDP7pi
    - user: root
    - enc: ssh-ed25519

/etc/sudoers:
  file.line:
    - mode: ensure
    - content: "%wheel ALL=(ALL) NOPASSWD: ALL"
    - before: "^## Allows people in group wheel"

prometheus:
  group.present

prometheus-user:
  user.present:
    - name: prometheus
    - fullname: Prometheus User
    - home: /srv/prometheus
    - groups:
      - prometheus

/home/cro/.local/provisioner:
  file.directory:
    - user: cro
    - group: cro
    - dir_mode: 755
    - file_mode: 644

/tmp/lunarviminstall.sh:
  file.managed:
    - source: https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh
    - skip_verify: True

bash /tmp/lunarviminstall.sh --no-install-dependencies && touch /home/cro/.local/provisioner/lunarvim.installed:
  cmd.run:
    - runas: cro
    - creates:
      - /home/cro/.local/provisioner/lunarvim.installed
    
/tmp/zellij.tar.gz:
  file.managed:
    - source: https://github.com/zellij-org/zellij/releases/download/v0.27.0/zellij-x86_64-unknown-linux-musl.tar.gz
    - skip_verify: True

extract_zellij:
  archive.extracted:
    - name: /tmp/zellij
    - source: /tmp/zellij.tar.gz
    - user: root
    - group: root
    - if_missing: /usr/local/bin/zellij
    - enforce_toplevel: False

/usr/local/bin/zellij:
  file.managed:
    - replace: False
    - source: /tmp/zellij/zellij
    - user: root
    - group: root
    - mode: '755'

/tmp/zellij:
  file.absent:
    - recurse: True

wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash:
  cmd.run:
    - creates:
      - /usr/local/bin/k3d

/home/cro/.config:
  file.recurse:
    - source: salt://files/.config
    - user: cro
    - group: cro

  

{% set NAME = pillar.items.get('humanname', 'C. R. Oldham') %}
{% set USER = pillar.items.get('username', 'cro') %}
{% set EMAIL = pillar.items.get('email', "cro@ncbt.org") %}
{% set HOME = pillar.items.get('homedir', "/home/cro") %}

Initial Packages:
  pkg.installed:
    - pkgs:
      - curl
      - gnupg

# Docker repositories for Fedora and Debian
{% if grains.get('os') == "Fedora" %}
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo:
  cmd.run:
    - creates: /etc/yum.repos.d/docker-ce.repo 
{% endif %}
{% if grains.get('os')== "Debian" %}
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg:
  cmd.run:
    - creates:
      - /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bullseye stable" > /etc/apt/sources.list.d/docker.list:
  cmd.run:
    - creates:
        - /etc/apt/sources.list.d/docker.list
{% endif %}
{% if grains.get('os')== "Ubuntu" %}
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg:
  cmd.run:
    - creates:
      - /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list:
  cmd.run:
    - creates:
        - /etc/apt/sources.list.d/docker.list
{% endif %}

Update Packages:
  pkg.uptodate:
    - refresh: True

# rtx repositories
{% if grains.get('os_family')== "Debian" %}
deb [signed-by=/etc/apt/keyrings/rtx-archive-keyring.gpg arch=amd64] https://rtx.pub/deb stable main:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/rtx.list
    - key_url: https://rtx.pub/gpg-key.pub
    - aptkey: False    
{% endif %}

Wanted Packages:
  pkg.installed:
    - pkgs:
        - hub
        - wget
        - neovim
        - fish
        - npm
        - ripgrep
        - fd-find
        - python3-neovim
        - keychain
        - sudo
        - tmux
{% if grains.get('os')== "Fedora" %}
        - gcc-c++
        - dnf-plugins-core
{% endif %}
{% if grains.get('os_family')== "Debian" %}
        - ca-certificates
        - lsb-release
        - rtx
{% endif %}

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
    - creates: /home/{{ USER }}/.pyenv
    - runas: {{ USER }}

{% if grains.get('os') == "Fedora" %}
Development Tools:
  pkg.group_installed

Development Libraries:
  pkg.group_installed
{% endif %}
{% if grains.get('os_family') == "Debian" %}
build-essential:
  pkg.installed
{% endif %}

yarn:
  npm.installed

pnpm:
  npm.installed 

neovim-npm:
  npm.installed:
    - name: neovim

{{ USER }}:
  user.present:
    - fullname: C. R. Oldham
    - home: /home/{{ USER }}
    - shell: /usr/bin/fish
    - groups:
      - docker
{% if grains.get('os') == "Debian" %}
      - sudo
{% endif %}
{% if grains.get('os') == "Fedora" %}
      - wheel
{% endif %}
    - password: "$6$qRKV9JUz4T7wyWFF$AsI2pgBqs9VOi8DkPKeqi3MIIIVtoxPvn7SnHpVa6f28vk2ZUsNjrmVO.zM1kYO1.x9Cc5dEK/K22YOimvg9r."

AAAAC3NzaC1lZDI1NTE5AAAAIL76QsHXnukwYpj1PcuLUW/detxKMs3ScBGt8kiDP7pi:
  ssh_auth.present:
    - user: {{ USER }}
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
  file.managed:
{% if grains.get('os') == "Fedora" %}
    - source: salt://wkst/files/sudoers.fedora
{% endif %}
{% if grains.get('os_family') == "Debian" %}
    - source: salt://wkst/files/sudoers.debian
{% endif %}
    - template: jinja
    - user: root
    - group: root
    - mode: '0600'

prometheus:
  group.present

prometheus-user:
  user.present:
    - name: prometheus
    - fullname: Prometheus User
    - home: /srv/prometheus
    - groups:
      - prometheus

/home/{{ USER }}/.local/provisioner:
  file.directory:
    - user: {{ USER }}
    - group: {{ USER }}
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True

/home/{{ USER }}/.local/provisioner/lunarviminstall.sh:
  file.managed:
    - source: https://raw.githubusercontent.com/lunarvim/lunarvim/rolling/utils/installer/install.sh
    - skip_verify: True

LV_BRANCH=rolling bash /home/{{ USER }}/.local/provisioner/lunarviminstall.sh --no-install-dependencies && touch /home/{{ USER }}/.local/provisioner/lunarvim.installed:
  cmd.run:
    - runas: {{ USER }}
    - creates: /home/{{ USER }}/.local/provisioner/lunarvim.group_installed

append-start-zone:
  file.append:
    - name: /home/{{ USER }}/.config/lvim/config.lua
    - text: "-- START managed zone -DO-NOT-EDIT-" 

append-end-zone:
  file.append:
    - name: {{ HOME }}/.config/lvim/config.lua
    - text: "-- END managed zone  --"

lunarvim-extra-plugins:
  file.blockreplace:
    - marker_start: "-- START managed zone -DO-NOT-EDIT-"
    - marker_end: "-- END managed zone  --"
    - name: {{ HOME }}/.config/lvim/config.lua
    - append_if_not_found: True
    - backup: '.bak'
    - show_changes: True
    - content: |
          -- Additional Plugins
          lvim.plugins = {
            {
              keys = { "c", "d", "y" },
              "tpope/vim-surround",
            },
            {
              "folke/trouble.nvim",
              cmd = "TroubleToggle",
            },
          }
    
/tmp/zellij.tar.gz:
  file.managed:
    - source: https://github.com/zellij-org/zellij/releases/download/v0.28.1/zellij-x86_64-unknown-linux-musl.tar.gz
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

/home/{{ USER }}/.config:
  file.recurse:
    - source: salt://wkst/files/.config
    - user: {{ USER }}
    - group: {{ USER }}

/etc/ssh/sshd_config.d/acceptenv.conf:
  file.managed:
    - source: salt://wkst/files/acceptenv.conf
    - user: root
    - group: root

/etc/ssh/ssh_config.d/sendenv.conf:
  file.managed:
    - source: salt://wkst/files/sendenv.conf
    - user: root
    - group: root

sshd:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/ssh/ssh_config.d/sendenv.conf
      - file: /etc/ssh/sshd_config.d/acceptenv.conf

git config --global user.email {{ EMAIL }}:
  cmd.run:
    - runas: {{ USER }}

git config --global user.name "{{ NAME }}":
  cmd.run:
    - runas: {{ USER }}



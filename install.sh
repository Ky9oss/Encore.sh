#!/bin/bash
#
# Restore my development environment
# By Ky9oss

banner() {
    cat << 'EOF'
           )
         ( _   _._
          |_|-'_~_`-._
       _.-'-_~_-~_-~-_`-._
   _.-'_~-_~-_-~-_~_~-_~-_`-._
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |  []  []   []   []  [] |
    |           __    ___   |
  ._|  []  []  | .|  [___]  |_._._._._._._._._._._._._._._._._.
  |=|________()|__|()_______|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|=|
^^^^^^^^^^^^^^^ === ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    _______      ===
   <_ky9oss_>       ===
      ^|^             ===
       |                 ===

EOF
}


#######################################
# Confirm next command.
# Globals:
#   None
# Arguments:
#   $1: desc
#   $@: command
#######################################
confirm() {
    local desc="${1:continue}"
    echo "${desc}"
    shift 1
    "$@"
}

cmd=(apt-get update)
confirm "update" "${cmd[@]}"

sudo usermod -aG sudo "$USER"
source .env


sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo tee /etc/apt/sources.list << 'EOF'
# Debian 13 bookworm
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware

deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
# deb-src https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF
sudo sh /media/cdrom0/VBoxLinuxAdditions.run


apt install -y build-essential dkms linux-headers-$(uname -r) perl make gcc g++ make cmake autoconf automake libtool pkg-config libc6 libc6-dev libstdc++6 libssl-dev libffi-dev zlib1g zlib1g-dev wget curl git unzip net-tools libevent-dev libncurses-dev yacc gcc-multilib g++-multilib libc6-dev-i386 libcurl4-openssl-dev
apt install -y vim curl wget net-tools lsof htop
apt-get install -y gdb zsh fzf ripgrep rsync jq bat zoxide fontconfig nodejs universal-ctags npm socat


# never sleep or suspend
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target


# proxychains-ng
sudo apt-get -y install proxychains-ng
sudo sed -i '/^\[ProxyList\]/,/^$/d' /etc/proxychains4.conf
sudo tee -a /etc/proxychains4.conf << 'EOF' 
[ProxyList]
socks5 ip port user pass

EOF
proxychains4 -q curl https://www.google.com # Return: Google Search


mkdir ~/tools


# tmux
cd ~/tools && proxychains4 git clone https://github.com/tmux/tmux && cd tmux && proxychains4 sh autogen.sh && ./configure && make
# [Error]
# fatal: unable to access 'https://github.com/tmux/tmux/': Failed to connect to github.com port 443 after 1 ms: Couldn't connect to server
sudo make install && tmux -V # tmux next-3.6
cd ~/tools && proxychains4 git clone --single-branch https://github.com/gpakosz/.tmux.git oh-my-tmux && cd ~/tools/oh-my-tmux
mkdir -p ~/.config/tmux
ln -s -f "${PWD}"/.tmux.conf ~/.config/tmux/tmux.conf 
cp "${PWD}"/.tmux.conf.local ~/.config/tmux/tmux.conf.local
mkdir -p ~/.tmux/plugins && cd ~/.tmux/plugins && proxychains4 git clone 'https://github.com/tmux-plugins/tmux-copycat' && proxychains4 git clone 'https://github.com/tmux-plugins/tmux-cpu' && proxychains4 git clone 'https://github.com/tmux-plugins/tmux-resurrect' && proxychains4 git clone 'https://github.com/aserowy/tmux.nvim'

proxychains4 -q wget https://raw.githubusercontent.com/Ky9oss/Encore.sh/refs/heads/main/tmux.conf.local -O ~/.config/tmux/tmux.conf.local




# ohmyzsh
proxychains4 -q sh -c "$(proxychains4 -q wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Time to change your default shell to zsh:
# Do you want to change your default shell to zsh? [Y/n]
mkdir -p ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
proxychains4 git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
proxychains4 git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# proxychains4 git clone https://github.com/jeffreytse/zsh-vi-mode.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
sudo tee ~/.zshrc << 'EOF'
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="clean"

# ohmyzsh plugins 
plugins=(git zsh-syntax-highlighting zsh-autosuggestions) # zsh-vi-mode
source $ZSH/oh-my-zsh.sh

# zoxide
eval "$(zoxide init zsh)"


EOF
source ~/.zshrc


# python - pyenv
sudo apt install -y build-essential zlib1g-dev libffi-dev libssl-dev \
    libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev \
    libncursesw5-dev tk-dev libgdbm-dev libdb-dev \
    uuid-dev
proxychains4 -q curl https://pyenv.run | proxychains4 -q sh
sudo tee -a ~/.zshrc << 'EOF'
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

EOF
source ~/.zshrc && proxychains -q pyenv update && proxychains4 -q pyenv install 3.14.0 && pyenv global 3.14.0


# rust
proxychains4 -q curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | proxychains4 -q sh
# 1) Proceed with standard installation (default - just press enter)
# 2) Customize installation
# 3) Cancel installation
# >
sudo tee -a ~/.zshrc << 'EOF'
# Rust
. "$HOME/.cargo/env"
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
export CARGO_TARGET_DIR="./"

EOF
source ~/.zshrc


# lua
cd ~/tools && proxychains4 -q git clone https://luajit.org/git/luajit.git
cd ~/tools/luajit && make && sudo make install
cd ~/tools && proxychains4 -q wget https://luarocks.org/releases/luarocks-3.13.0.tar.gz && tar zxpf luarocks-3.13.0.tar.gz
cd ~/tools/luarocks-3.13.0 && ./configure && make && sudo make install
mkdir ~/tools/lua_ls && cd ~/tools/lua_ls && proxychains4 -q wget https://github.com/LuaLS/lua-language-server/releases/download/3.17.1/lua-language-server-3.17.1-linux-x64.tar.gz && tar -zxvf lua-language-server-3.17.1-linux-x64.tar.gz
sudo tee -a ~/.zshrc << 'EOF'
export PATH=~/tools/lua_ls/bin:$PATH

EOF
# need rust
cargo install stylua --features luajit
source ~/.zshrc

# c/cpp
sudo apt-get install clang-format

# radare2
cd ~/tools && proxychains4 -q git clone https://github.com/radareorg/radare2 && chmod +x radare2/sys/install.sh && proxychains4 -q radare2/sys/install.sh

# rockyou
mkdir ~/tools/wordlists && cd ~/tools/wordlists && proxychains4 -q git clone https://github.com/zacheller/rockyou && cd rockyou && tar -zxvf ./rockyou.txt.tar.gz

# nvim
cd ~/tools && proxychains4 -q wget https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.tar.gz && tar -zxvf ./nvim-linux-x86_64.tar.gz
sudo tee -a ~/.zshrc << 'EOF'
export EDITOR="/usr/sbin/nvim"
export PATH=~/tools/nvim-linux-x86_64/bin:$PATH

EOF

# spectervim
mv ~/.config/nvim ~/.config/nvim_bak
proxychains -q git clone https://github.com/Ky9oss/SpecterVim ~/.config/nvim
source ~/.zshrc

# kvm
sudo apt install cpu-checker qemu-kvm libvirt-clients libvirt-daemon-system virt-manager -y

# bash
sudo apt install shellcheck

# git
git config --global core.autocrlf false
git config --global credential.helper manager-core

# Encore.sh

<div align="left">
    <img src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg" alt="made-with-Bash">
    <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" alt="Maintenance">
    <img src="https://img.shields.io/badge/Maintainer-Ky9oss-red" alt="Maintainer">
    <br>
    <br>
    <br>
</div>

A `bash` script to restore my development environment.

```txt
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

```

## QuickStart

Set up `env-dev.conf` in the same dir as `install.sh`

```txt
 PROXY_PROTOCAL=socks
 PROXY_IP=x.x.x.x
 PROXY_PORT=xx
 PROXY_USER=xxx
 PROXY_PASS=xxx
```

Then run:

```sh
su root
./install.sh
```

## Configure

- install basic libs
- install useful tools
- install asm dev env
- install c dev env
- install lua dev env
- install python dev env
- install rust dev env
- install and configure tmux
- install and configure neovim
- install and configure zsh
- set current user sudoer
- set ssh server and auto register the active info in remote server

## Test

- Docker
- bats-core

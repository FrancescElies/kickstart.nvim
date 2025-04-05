set shell := ["nu", "-c"]

alias b := bootstrap

[windows]
bootstrap: minimal-vimrc-folders
    mklink /D ("~/AppData/Local/nvim" | path expand --no-symlink) ("~/src/kickstart.nvim" | path expand --no-symlink)
    mklink ("~/_vimrc" | path expand --no-symlink) ("~/src/kickstart.nvim/minimal-vimrc.vim" | path expand --no-symlink)

[macos]
bootstrap: minimal-vimrc-folders
    ln -shf "~/src/kickstart.nvim"  "~/.config/nvim"
    ln -shf ~/src/kickstart.nvim/minimal-vimrc.vim  ~/.vimrc

[linux]
bootstrap: minimal-vimrc-folders
    ln -snf "~/src/kickstart.nvim"  "~/.config/nvim"
    ln -snf ~/src/kickstart.nvim/minimal-vimrc.vim  ~/.vimrc

minimal-vimrc-folders:
    mkdir ~/.vim/files/backup
    mkdir ~/.vim/files/swap
    mkdir ~/.vim/files/undo


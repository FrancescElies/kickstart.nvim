match $nu.os-info.name {
    "windows" => {
        mklink /D ("~/AppData/Local/nvim" | path expand --no-symlink) ("~/src/kickstart.nvim" | path expand --no-symlink)
        mklink ("~/_vimrc" | path expand --no-symlink) ("~/src/kickstart.nvim/minimal-vimrc.vim" | path expand --no-symlink)
},
    _ => {
        # add symlinks for guis :echo stdpath('config') will show where the gui expects the config path
        mkdir ~/.var/app/dev.neovide.neovide/config
        ln -snf ("~/src/kickstart.nvim" | path expand --no-symlink) ("~/.var/app/dev.neovide.neovide/config/nvim" | path expand --no-symlink)
        mkdir ~/.var/app/io.neovim.nvim/config
        ln -snf ("~/src/kickstart.nvim" | path expand --no-symlink) ("~/.var/app/io.neovim.nvim/config/nvim" | path expand --no-symlink)

        ln -snf ("~/src/kickstart.nvim" | path expand --no-symlink) ("~/.config/nvim" | path expand --no-symlink)
        mkdir ~/.vim/files/backup
        mkdir ~/.vim/files/swap
        mkdir ~/.vim/files/undo
        ln -snf ("~/src/kickstart.nvim/minimal-vimrc.vim" | path expand --no-symlink) ("~/.vimrc" | path expand --no-symlink)
    },
}

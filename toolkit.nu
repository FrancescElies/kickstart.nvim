const repo_dir = path self .

# Create a symlink
def symlink [
    existing: path   # The existing file
    new_link_name: path  # The name of the symlink
    --force(-f)     # if target exists moves it to
] {
    print $"(ansi purple_bold)Creating symlink(ansi reset) ($existing) --> ($new_link_name)"
    if (not ($existing | path exists)) {
        print $"(ansi purple_bold)not found: (ansi reset) ($existing)"
        return
    }
    let existing = ($existing | path expand --strict | path split | path join)
    let $new_link_name = ($new_link_name | path expand --no-symlink | path split | path join)


    # create parent folder if it doesn't exist
    mkdir -v ($new_link_name | path dirname)

    if ($force and ($new_link_name | path exists)) {
       rm --recursive $new_link_name
    }

    if $nu.os-info.family == 'windows' {
        if ($existing | path type) == 'dir' {
            print $"dir link created ($new_link_name)"
            mklink /D $new_link_name $existing
        } else {
            print $"file link created ($new_link_name)"
            mklink $new_link_name $existing
        }
    } else {
        print $"link created ($new_link_name)"
        ln -s $existing $new_link_name | ignore
    }
}

export def bootstrap [] {
    match $nu.os-info.name {
        "windows" => {
            symlink --force $repo_dir "~/AppData/Local/nvim"
            symlink --force ( $repo_dir | path join "minimal-vimrc.vim" ) "~/_vimrc"
    },
        _ => {
            # add symlinks for guis :echo stdpath('config') will show where the gui expects the config path
            symlink --force $repo_dir "~/.var/app/dev.neovide.neovide/config/nvim"
            symlink --force $repo_dir "~/.var/app/io.neovim.nvim/config/nvim"
            symlink --force $repo_dir "~/.config/nvim"
            mkdir -v ~/.vim/files/backup ~/.vim/files/swap ~/.vim/files/undo
            symlink --force "~/src/kickstart.nvim/minimal-vimrc.vim" "~/.vimrc"
        },
    }
}

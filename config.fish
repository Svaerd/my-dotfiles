# oh-my-posh init fish --config ~/.oh-my-posh/powerlevel10k_rainbow.omp.json | source
#set -x KITTY_CONFIG_DIRECTORY ~/.config/kitty/kitty/kitty.conf
fzf --fish | source
zoxide init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here

    function welcome_message
        #figlet "Sup?" -f nvcript -tk | lolcat
        fastfetch
    end

    function fish_greeting
        welcome_message
    end

    function ff
        fzf
    end

    function cl
        clear && fish
    end

    function zi
        set -l result (command zoxide query --interactive -- $argv)
        and __zoxide_cd $result
    end
end

# Created by `pipx` on 2025-03-23 07:43:22
set PATH $PATH /home/archam/.local/bin

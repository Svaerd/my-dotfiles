# oh-my-posh init fish --config ~/.oh-my-posh/powerlevel10k_rainbow.omp.json | source
#set -x KITTY_CONFIG_DIRECTORY ~/.config/kitty/kitty/kitty.conf
fzf --fish | source
zoxide init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here

    #==================
    # my function
    #==================

    function welcome_message
        #figlet "Sup?" -f nvcript -tk | lolcat
        fastfetch
        neo --charset=greek -s -D -c purple --colormode=32 -d 0.85 -m "I use Arch BTW"
    end

    function fish_greeting
        welcome_message
    end

    # just fzf, but with a great buff which make it looks nicer and easier to use
    function ff
        fzf -m --style full \
            --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'
    end

    #this is more of an abbreviation, but whatever
    function fd
        fzf-cd-widget
    end

    #clear the terminal and refresh the fish shell
    function cl
        clear && fish
    end

    #zoxide, but interactive
    function zi
        set -l result (command zoxide query --interactive -- $argv)
        and __zoxide_cd $result
    end

    # yazi, but with the abbility to change dir upon quit
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    #=================
    # my abbreviation
    #=================

    #abbreviation to start zellij with a certain session
    abbr -a ze --set-cursor "zellij a % options --theme catppuccin-macchiato"
    #abbreviation to start zellij with a new session
    abbr -a zen --set-cursor "zellij -s % options --theme catppuccin-macchiato"
    abbr -a snv sudo -E -s nvim
end

# Created by `pipx` on 2025-03-23 07:43:22
set PATH $PATH /home/archam/.local/bin

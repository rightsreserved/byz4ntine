# byz4ntine fish config

set fish_greeting

# prompt clean up
function fish_mode_prompt
  printf ''
end

# shortcuts
abbr p "pacman"
abbr pp "sudo pacman"
abbr upd "sudo pacman -Sy"
abbr upg "sudo pacman -Syu"
abbr install "sudo pacman -Sy && sudo pacman -S"
abbr search "trizen -Ss"
abbr spotify "flatpak run com.spotify.Client"
abbr key "sudo pacman-key --refresh-keys"

# config
abbr config "micro ~/.config/i3/config"
abbr polyconf "micro ~/.config/polybar/config"
abbr fishconf "micro ~/.config/fish/config.fish"
abbr termconf "micro ~/.config/termite/config"
abbr alacconf "micro ~/.config/alacritty/alacritty.yml"
abbr dunstconf "micro ~/.config/dunst/dunstrc"

# clear screen
abbr c "clear && figlet byz4ntine | rainbow"
abbr x "clear && neofetch"
abbr z "clear && aura"

# start up theming
figlet byz4ntine | rainbow

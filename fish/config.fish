# byz4ntine fish config

set fish_greeting

# prompt clean up
function fish_mode_prompt
  printf ''
end

# shortcuts
abbr d "doas"
abbr p "pacman"
abbr pp "doas pacman"
abbr upd "doas pacman -Sy"
abbr upg "doas pacman -Syu"
abbr search "trizen -Ss"
abbr spotify "flatpak run com.spotify.Client"

# config
abbr config "micro ~/.config/i3/config"
abbr fishconf "micro ~/.config/fish/config.fish"
abbr doasconf "doas nano /etc/doas.conf"
abbr termconf "micro ~/.config/termite/config"
abbr alacconf "micro ~/.config/alacritty/alacritty.yml"

# clear screen
abbr c "clear && figlet byz4ntine | rainbow"
abbr x "clear && neofetch"
abbr z "clear && aura"

# start up theming
figlet byz4ntine | rainbow

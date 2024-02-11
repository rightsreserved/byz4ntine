# elsatarian fish config

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
abbr i "sudo pacman -Sy && sudo pacman -S"
abbr sc "trizen -Ss"
abbr key "sudo pacman-key --refresh-keys"

# config
abbr config "micro ~/.config/i3/config"
abbr piconf "micro ~/.config/picom.conf"
abbr fishconf "micro ~/.config/fish/config.fish"
abbr termconf "micro ~/.config/termite/config"
abbr alacconf "micro ~/.config/alacritty/alacritty.toml"
abbr dunstconf "micro ~/.config/dunst/dunstrc"

# clear screen
abbr a "clear && pfetch"
abbr f "clear && figlet faith | rainbow"
abbr x "clear && neofetch"
abbr a "clear && fet.sh"

# start up theming
pfetch

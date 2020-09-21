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
abbr i "sudo pacman -Sy && sudo pacman -S"
abbr sc "trizen -Ss"
abbr key "sudo pacman-key --refresh-keys"

# config
abbr config "micro ~/.config/i3/config"
abbr piconf "micro ~/.config/picom/picom.conf"
abbr polyconf "micro ~/.config/polybar/config"
abbr fishconf "micro ~/.config/fish/config.fish"
abbr termconf "micro ~/.config/termite/config"
abbr miniconf "micro ~/.config/miniterm/miniterm.conf"
abbr alacconf "micro ~/.config/alacritty/alacritty.yml"
abbr dunstconf "micro ~/.config/dunst/dunstrc"

# clear screen
abbr a "clear && pfetch"
abbr c "clear && fet.sh"
abbr d "clear && cpufetch"
abbr f "clear && figlet byz4ntine | rainbow"
abbr s "clear && screenfetch"
abbr x "clear && neofetch"
abbr z "clear && aura"

# start up theming
fet.sh

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
abbr mca "java --module-path Documents/javaJFX/javafx-sdk-16/lib/ --add-modules ALL-MODULE-PATH -jar Downloads/mcaselector-1.16.3.jar
"

# config
abbr config "micro ~/.config/i3/config"
abbr swayconf "micro ~/.config/sway/config"
abbr piconf "micro ~/.config/picom/picom.conf"
abbr polyconf "micro ~/.config/polybar/config"
abbr fishconf "micro ~/.config/fish/config.fish"
abbr termconf "micro ~/.config/termite/config"
abbr miniconf "micro ~/.config/miniterm/miniterm.conf"
abbr alacconf "micro ~/.config/alacritty/alacritty.yml"
abbr dunstconf "micro ~/.config/dunst/dunstrc"
abbr promptconf "micro ~/.config/starship.toml"

# clear screen
abbr a "clear && pfetch"
abbr s "clear && neofetch | lolcat"
abbr d "clear && nekofetch"
abbr f "clear && figlet faith | rainbow"
abbr c "clear && neofetch | pridecat --trans"
abbr x "clear && fet.sh"
abbr z "clear && colorscript exec colorbars"
abbr v "clear && neofetch | pridecat --trans --lesbian"
abbr b "clear && colorscript exec colortest"

# start up theming
neofetch | pridecat --trans

# prompt

# starship init fish | source

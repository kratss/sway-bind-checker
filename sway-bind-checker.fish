#!/usr/bin/env fish
# Indicate used and unused shortcuts in sway

function keycheck
set -g keys_unbound $keys
set i 0
for key in $keys
    set i (math $i + 1)
    if string match --quiet --entire -- $key $argv
        set keys_unbound[$i] ""
    end
end
set i 1
for key in $keys_unbound
    if test -z "$key"
        set -e keys_unbound[$i]
    else
        set i (math $i +1)
    end
end
end

set conf $(cat $argv)
set full_line (string match -e -r 'bindsym*' $conf)
set command (string match -r 'bindsym\s[$a-zA-Z0-9-+]*' $conf)
set command (string replace 'bindsym ' ''  $command)
set command_mod (string match -- '*mod*' $command)

set command_mod (string replace -r -- '\$mod\+' '' $command)
set command_mod_nill (string match --invert -- '*Shift*' $command_mod)
set command_mod_shift (string match -- '*Shift*' $command_mod)
set command_mod_shift (string replace -r -- 'Shift\+' '' $command_mod_shift)
set command_mod_alt (string match -- '*Alt*' $command_mod)
set command_mod_alt (string replace -r -- 'Alt\+' '' $command_mod_alt)
set command_ctrl 
set command_ctrl_shift

#todo: get % to work
set keys a b c d e f g h i j k l m n o p q r s t u v w x y z\
    "`" 1 2 3 4 5 6 7 8 9 0 "-" "+" \
    "~" "!" "@" "#" "\$" "^" "&" \* \( \) "_" "+" \
    \; \' ":" \" \
    "," "." "/" \
    "<" ">" "?"



keycheck $command_mod_nill
printf "\nUnbound \$mod: $keys_unbound"

keycheck $command_mod_shift
printf "\nunbound \$mod+Shift: $keys_unbound"

keycheck $command_mod_alt
printf "\nunbound \$mod+Alt: $keys_unbound"



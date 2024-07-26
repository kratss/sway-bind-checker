#!/usr/bin/env fish
# Read used and unused bindings from sway config 
# Usage: Pass any sway config file to see a list of available bindings
# TODO: Detect key bindings set in variables. E.g. default config sets j
# to $left and uses $left in bindings

argparse "h/help" -- $argv
if test -n "$_flag_help"
    echo "Usage: Pass any sway config file to see a list of available bindings"
    return
else if test -z "$argv"
    echo "Error: Requires sway config file as argument"
    return
end

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
set cmnd (string match -r 'bindsym\s[$a-zA-Z0-9-+]*' $conf)
set cmnd (string replace 'bindsym ' ''  $cmnd)
set cmnd_mod (string replace -f -r -- '\$mod\+' '' $cmnd)
set cmnd_mod_nill (string match -v -- '*Shift*' $cmnd_mod | \
    string match -v -- '*Alt*')
set cmnd_mod_shift (string replace -f -r -- 'Shift\+' '' $cmnd_mod | \
    string match --invert -- '*Alt*')
set cmnd_mod_alt (string replace -f -r -- 'Alt\+' '' $cmnd_mod | \
    string match --invert -- '*Shift*')

set keys a b c d e f g h i j k l m n o p q r s t u v w x y z\
    "`" 1 2 3 4 5 6 7 8 9 0 "-" "+" \
    "~" "!" "@" "#" "%" "\$" "^" "&" \* \( \) "_" "+" \
    \; \' ":" \" \
    "," "." "/" \
    "<" ">" "?"

printf '\nUnbound keys:\n'
keycheck $cmnd_mod_nill
printf '$mod+%s\n' $keys_unbound | column
printf '\n'
keycheck $cmnd_mod_shift
printf '$mod+Shift+%s\n' $keys_unbound | column
printf '\n'
keycheck $cmnd_mod_alt
printf '$mod+Alt+%s\n' $keys_unbound | column
printf '\n'
echo "Currently bound keys: "
printf '$mod+%s\n' $cmnd_mod_nill | column
printf '\n'
printf '$mod+Shift+%s\n' $cmnd_mod_shift | column
printf '\n'
printf '$mod+Alt+%s\n' $cmnd_mod_alt | column


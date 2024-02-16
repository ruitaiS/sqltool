#!/bin/bash

logins_file='logins.gpg'
logins=''
env='local'
host=''
user=''
pass=''

schemas=()
selected_schema=()
tables=()
selected_tables=()
filename=()

decrypt_credentials() {
    if [ -f "$logins_file" ]; then
        logins=$(sudo gpg -d "$logins_file")
    else
        echo "Error: No encrypted credentials file found."
        exit 0
    fi
}

assign_credentials() {
    env="$1"
    read host user pass <<<$(echo "$logins" | awk -F',' -v Environment="$env" '$1 == Environment {print $2" "$3" "$4}')
}

decrypt_credentials
assign_credentials $env

prompt="Environment: $env\nSelect Operation:"
options=(
    1 "Select Environment (Current: $env)"
    2 "Select Database (Current: $selected_schema)"
    3 "Select Tables (Current: $selected_tables)"
    4 "Create Dump File (Filename: $filename)"
    5 "Load Dump File"
    q "Quit"
)

selection=$(dialog --stdout --title "Main Menu" --ok-label "Select" --cancel-label "Quit" --menu "$prompt" 20 60 10 "${options[@]}" )

# Check if user pressed Quit
if [ $? -eq 1 ]; then
    clear
    echo "Goodbye!"
    exit 0
fi

case $selection in
    1)
        #select_env
        ;;
    2)
        #select_schema
        ;;
    3)
        #dump_data
        ;;
    q)
        clear
        echo "Goodbye!"
        exit 0
        ;;
    Q)
        clear
        echo "Goodbye!"
        exit 0
        ;;
esac
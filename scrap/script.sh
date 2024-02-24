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

select_env() {
prompt="Environment: $env\nHost: $host\nUser: $user\nPassword: $pass"
options=(
    1 "Local"
    2 "Dev"
    3 "Stabledev"
    x "Back (Keep Current)"
)

selection=$(dialog --stdout --title "Select Environment" --ok-label "Select" --cancel-label "Back" --menu "$prompt" 20 60 10 "${options[@]}" )
if [ $? -eq 1 ]; then
    clear
    return
fi
        case $selection in
        1)
            assign_credentials 'local'
            clear
            return
            ;;
        2)
            assign_credentials 'dev'
            clear
            return
            ;;
        3)
            assign_credentials 'stabledev'
            clear
            return
            ;;
        x)
            clear
            return
            ;;
        esac
}

decrypt_credentials
assign_credentials $env

prompt="Environment: $env\nDatabase: $selected_schema\nTables: $selected_tables\nFilename: $filename"
options=(
    1 "Change Environment"
    2 "Select Database"
    3 "Select Tables"
    4 "Create Dump File"
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
        select_env
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
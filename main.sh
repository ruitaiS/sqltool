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

# Function to display Change Environment menu
change_environment_menu() {
    dialog --msgbox "Change Environment menu placeholder" 10 40
}

# Function to display Select Database menu
select_database_menu() {
    dialog --msgbox "Select Database menu placeholder" 10 40
}

# Function to display Select Tables menu
select_tables_menu() {
    dialog --msgbox "Select Tables menu placeholder" 10 40
}

# Function to display Create Dump File menu
create_dump_file_menu() {
    dialog --msgbox "Create Dump File menu placeholder" 10 40
}

# Function to display Load Dump File menu
load_dump_file_menu() {
    dialog --msgbox "Load Dump File menu placeholder" 10 40
}

#--------------Main Execution Loop

decrypt_credentials
assign_credentials $env

while true; do
    prompt="Environment: $env\nDatabase: $selected_schema\nTables: $selected_tables\nFilename: $filename"
    options=(
        1 "Change Environment"
        2 "Select Database"
        3 "Select Tables"
        4 "Create Dump File"
        5 "Load Dump File"
        q "Quit"
    )

    selection=$(dialog --stdout --title "Main Menu" --ok-label "Select" --cancel-label "Quit" --menu "$prompt" 20 60 10 "${options[@]}")

    if [ -z "$selection" ]; then
        clear
        echo "Goodbye!"
        exit 0
    fi

    case $selection in
        1)
            change_environment_menu
            ;;
        2)
            select_database_menu
            ;;
        3)
            select_tables_menu
            ;;
        4)
            create_dump_file_menu
            ;;
        5)
            load_dump_file_menu
            ;;
        q)
            clear
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please select again."
            ;;
    esac
done

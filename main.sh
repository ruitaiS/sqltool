#!/bin/bash

logins_file='logins.gpg'
logins=''
env='local'
selected_schema=''
host=''
user=''
pass=''


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
    selected_schema=''
    read host user pass <<<$(echo "$logins" | awk -F',' -v Environment="$env" '$1 == Environment {print $2" "$3" "$4}')
}

change_environment_menu() {
    prompt="Environment: $env\nHost: $host\nUser: $user\nPassword: $pass"
    options=(
        1 "Local"
        2 "Dev"
        3 "Stabledev"
        x "Back (Keep Current)"
    )

    selection=$(dialog --stdout --title "Select Environment" --ok-label "Select" --cancel-label "Back" --menu "$prompt" 20 60 10 "${options[@]}")
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

select_schema_menu() {
    #echo "Loading data..."
    schemas=$(timeout 10 mysql -h "$host" -u "$user" -p"$pass" -e "SHOW DATABASES;" | awk '{if (NR>1) print $1}')
    #echo ""

    if [ -n "$schemas" ]; then
        #echo "Schemas on $env: "
        #echo ""
        options=()
        while IFS= read -r schema_name; do
            options+=("$schema_name" "")
        done <<< "$schemas"
        selected_schema=$(dialog --stdout --title "Select Schema" --menu "Choose a schema:" 20 60 10 "${options[@]}")
    else
        #TODO: Make this a dialog screen with an ok button
        #Should prompt to select a different environment
        echo "Error: Timeout occurred or command failed. Please check connection and/or credentials."
        echo ""
    fi
}

select_tables_menu() {
    #TODO: Verify there is a schema selected first
    tables=$(timeout 10 mysql -h "$host" -u "$user" -p"$pass" -e "USE $selected_schema; SHOW TABLES;" | awk '{if (NR>1) print $1}')
    #echo ""

    if [ -n "$tables" ]; then
        #echo "Schemas on $env: "
        #echo ""
        options=()
        while IFS= read -r table_name; do
            options+=("$table_name" "" off) #TODO: Remember the on/off state until the schema or the env changes
        done <<< "$tables"
        selected_tables=$(dialog --stdout --title "Select Tables" --checklist "Choose tables (Space to Select; Enter to Accept):" 20 60 10 "${options[@]}")

    else
        #TODO: Make this a dialog screen with an ok button
        #Should prompt to select a different environment
        echo "Error: Timeout occurred or command failed. Please check connection and/or credentials."
        echo ""
    fi
}

create_dump_file_menu() {
    dialog --msgbox "Create Dump File menu placeholder" 10 40
}

load_dump_file_menu() {
    dialog --msgbox "Load Dump File menu placeholder" 10 40
}

#--------------Main Execution Loop

decrypt_credentials
assign_credentials $env

while true; do
    prompt="Environment: $env\nSchema: $selected_schema\nTables: $selected_tables\nFilename: $filename"
    options=(
        1 "Change Environment"
        2 "Select Schema"
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
        select_schema_menu
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

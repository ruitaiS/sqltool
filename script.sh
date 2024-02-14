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

list_schemas() {
    echo "Loading data..."
    schemas=$(timeout 10 mysql -h "$host" -u "$user" -p"$pass" -e "SHOW DATABASES;" | awk '{if (NR>1) print $1}')
    echo ""

    if [ -n "$schemas" ]; then
        echo "Schemas on $env: "
        echo ""
        echo "$schemas"
        echo ""

    else
        # The command timed out or encountered an error
        echo "Error: Timeout occurred or command failed. Please check connection and/or credentials."
        echo ""
    fi
}

select_schema() {
    clear
    schemas=$(timeout 10 mysql -h "$host" -u "$user" -p"$pass" -e "SHOW DATABASES;" | awk '{if (NR>1) print $1}')
    #echo "$schemas"
    #whiptail "$schemas"
    # Convert the list into an array for easier manipulation
    IFS=$'\n' read -r -d '' -a schema_array <<<"$schemas"

    # Create an array to store menu options
    options=()
    for schema in "${schema_array[@]}"; do
        options+=("$schema" "")
    done

    # Show menu using whiptail and capture user selection
    #selected_schema=$(whiptail --title "Schema Selection" --menu "Choose a schema:" 20 60 10 "${options[@]}" 3>&1 1>&2 2>&3)
    selected_schema=$(dialog --stdout --title "Schema Selection" --menu "Choose a schema:" 20 60 10 "${options[@]}")
    clear

    # Check if user pressed Cancel or Escape
    if [ $? -ne 0 ]; then
        echo "No schema selected. Exiting."
        exit 1
    fi

    # Print selected schema for verification
    echo "Selected schema: $selected_schema"

}

# Function to handle 'Dump' option
dump_data() {
    echo "Dumping data..."
    echo "Schema: $schema"
    echo "Tables: $tables"
    # Add your 'Dump' logic here
}

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

# Function to handle 'Change Credentials' option
select_env() {
    while true; do
        echo "Current:"
        echo "Environment: $env"
        echo "Host: $host"
        echo "User: $user"
        echo "Password: $pass"
        echo ""
        echo "[Main Menu]>>[3. Select Environment]"
        read -p "Select Environment:
1 - Local
2 - Dev
3 - Stabledev
x - Exit (Keep Current)
Selection: " choice

        case $choice in
        1)
            assign_credentials 'local'
            echo ""
            echo "Updated Environment:"
            echo "Environment: $env"
            echo "Host: $host"
            echo "User: $user"
            echo "Password: $pass"
            echo ""
            break
            ;;
        2)
            assign_credentials 'dev'
            echo ""
            echo "Updated Environment:"
            echo "Environment: $env"
            echo "Host: $host"
            echo "User: $user"
            echo "Password: $pass"
            echo ""
            break
            ;;
        3)
            #change_credentials
            assign_credentials 'stabledev'
            echo ""
            echo "Updated Environment:"
            echo "Environment: $env"
            echo "Host: $host"
            echo "User: $user"
            echo "Password: $pass"
            echo ""
            break
            ;;
        x)
            echo ""
            break
            ;;
        *)
            echo "Invalid choice."
            ;;
        esac
    done
}

# Main script
echo "MySQL DB Management Tool"
decrypt_credentials
assign_credentials $env
echo "Environment: $env"
echo ""
while true; do
    echo "[Main Menu]"
    read -p "Select Operation:
1 - Select Environment (Current: $env)
2 - Select Database (Current: $selected_schema)
# - Select Tables (Current: $selected_tables)
# - Create Dump File (Filename: $filename)
# - Load Dump File
q - Quit
Selection: " choice

    case $choice in
    1)
        echo ""
        select_env
        ;;
    2)
        echo ""
        select_schema
        ;;
    3)
        echo ""
        dump_data
        ;;
    q)
        echo "Goodbye!"
        exit 0
        ;;
    Q)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo ""
        echo "Invalid choice."
        echo ""
        ;;
    esac
done

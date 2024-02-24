#!/bin/bash

while true; do
    # Main menu
    choice=$(dialog --menu "Main Menu" 10 40 3 1 "Option 1" 2 "Option 2" 3 "Exit" 2>&1 >/dev/tty)

    case $choice in
        1)
            while true; do
                # Secondary menu 1
                sub_choice=$(dialog --menu "Secondary Menu 1" 10 40 3 1 "Suboption 1" 2 "Suboption 2" 3 "Back" 2>&1 >/dev/tty)

                case $sub_choice in
                    1)
                        echo "Perform action for Suboption 1"
                        ;;
                    2)
                        echo "Perform action for Suboption 2"
                        ;;
                    3)
                        break  # Return to main menu
                        ;;
                esac
            done
            ;;
        2)
            while true; do
                # Secondary menu 2
                sub_choice=$(dialog --menu "Secondary Menu 2" 10 40 3 1 "Suboption A" 2 "Suboption B" 3 "Back" 2>&1 >/dev/tty)

                case $sub_choice in
                    1)
                        echo "Perform action for Suboption A"
                        ;;
                    2)
                        echo "Perform action for Suboption B"
                        ;;
                    3)
                        break  # Return to main menu
                        ;;
                esac
            done
            ;;
        3)
            echo "Exiting..."
            exit 0
            ;;
    esac
done
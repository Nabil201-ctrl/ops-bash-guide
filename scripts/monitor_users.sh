#!/usr/bin/bash

#---List the Users on this pc ---

# Read users from /etc/passwd into an array
mapfile -t users < <(cut -d: -f1 /etc/passwd)

# Initialize options array
options=()

# Populate options and display users
for user in "${users[@]}"; do
    options+=("$user")
    echo "The user is $user"
done

# Get current user
current_user=$(whoami)
echo "The current user is $current_user"

echo "Please delete anyone of the users you are not using"

# Display menu and handle selection
PS3='Select a user to delete (or press Enter to cancel): '
select opt in "${options[@]}"; do
    case $opt in
        "")
            echo "No valid option selected. Exiting."
            break
            ;;
        "$current_user")
            echo "Cannot delete the current user: $current_user"
            ;;
        *)
            echo "You selected to delete user: $opt"
                userdel "$opt"
            break
            ;;
    esac
done   
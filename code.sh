#!/bin/bash

echo "Welcome to the Community Chat"
echo "It's a space where you can chat with your neighbors or any public rooms"
# Function to register 
register_user() {
    echo "Enter your username:"
    read username
    echo "Enter your neighborhood:"
    read neighborhood
    echo "$username:$neighborhood" >> users.txt
    if [ ! -e "$neighborhood.txt" ]; then
        touch "$neighborhood.txt"
    fi
    echo "You have been registered successfully!"
    
}

# Function to login 
login_user() {
    echo "Enter your username:"
    read username
    if grep -q "$username" users.txt; then
        echo "Login successful!"
        neighborhood=$(grep "$username" users.txt | cut -d':' -f2)
    else
        echo "Username not found. Please register first."
        exit 1
    fi
}

# Function to create or enter a chat room
public_chat_room() {
    echo "Enter the name of the chat room:"
    read room_name
    if [ ! -e "$room_name.txt" ]; then
        touch "$room_name.txt"
    fi
    echo "1. Send a message"
    echo "2. Read messages"
    echo "Enter your choice:"
    read choice
    case $choice in
        1) send_message "$room_name" ;;
        2) read_messages "$room_name" ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
}

# Function to start chatting
start_chatting() {
    local neighborhood=$1
    echo "1. Send a message"
    echo "2. Read messages"
    echo "Enter your choice:"
    read choice
    case $choice in
        1) send_message "$neighborhood" ;;
        2) read_messages "$neighborhood" ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
}

# Function to send a message 
send_message() {
    local room=$1
    echo "Enter your message :"
    read message
    clean_message=$(echo "$message" | sed 's/^[ \t]//;s/[ \t]$//;s/ \{1,\}/ /g')
    echo "$(date +"%F %T") - $username: $clean_message" >> "$room.txt"
    echo "Message sent successfully!"
}

# Function to read message 
read_messages() {
    local room=$1
    echo "1. Specific message"
    echo "2. All messages"
    echo "Enter your choice:"
    read choice

    case $choice in
        1) specific_message "$room" ;;
        2) all_messages "$room" ;;
        *) echo "Invalid choice. Please try again." ;;
    esac  
}

# Function to read all messages from a chat room
all_messages() {
    local room=$1
    cat "$room.txt"
}

# Function to read specific messages from a specific chat room
specific_message() {
    local room=$1
    echo "Write the word you want to search: "
    read word
    if grep -q "$word" "$room.txt"; then
        grep "$word" "$room.txt"
    else
        echo "No matches found for '$word' in $room.txt"
    fi
}

# Function to update username
update_username() {
    echo "Enter your old username:"
    read old_username
    if grep -q "$old_username" users.txt; then
        echo "Enter your new username:"
        read new_username
        sed -i "s/$old_username/$new_username/" users.txt
        for file in *.txt; do
            sed -i "s/$old_username/$new_username/g" "$file"
        done

        echo "Username updated successfully!"
    else
        echo "Username not found."
    fi
}

# Function to show users and neighborhoods
show_users_and_neighborhoods() {
    echo "List of users and their neighborhoods:"
    while IFS=: read -r username neighborhood; do
        echo "Username: $username, Neighborhood: $neighborhood"
    done < users.txt
}

# Initial menu
echo "1. Register a new user"
echo "2. Login"
echo "3. Exit"
echo "Enter your choice:"
read initial_choice

case $initial_choice in
    1)  register_user ;;
    2) login_user ;;
    3)  exit ;;
    *) 
        echo "Invalid choice. Please try again." 
esac

# Main menu after login
while true; do
    echo "1. Start chatting"
    echo "2. Public chat room"
    echo "3. Read messages from a chat room"
    echo "4. Update username"
    echo "5. Show users and neighborhoods"
    echo "6. Exit"
    echo "Enter your choice:"
    read choice

    case $choice in
        1) start_chatting "$neighborhood" ;;
        2) public_chat_room ;;
        3) 
            echo "Enter the name of the chat room:"
            read room_name
            read_messages "$room_name"
            ;;
        4) update_username ;;
        5) show_users_and_neighborhoods ;;
        6) exit ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done

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
    else
        echo "Username not found. Please register first."
        exit 1
    fi
}

# Function to create a new chat room
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

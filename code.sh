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
}                                                                                                                                                                                   # Function to read message 
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
}                                                                                                                                                                                   # Function to read all messages from a chat room
all_messages() {
    local room=$1
    cat "$room.txt"
}                                                                                                                                                                                   # Function to read specific messages from a specific chat room
specific_message() {
    local room=$1
    echo "Write the word you want to search: "
    read word
    if grep -q "$word" "$room.txt"; then
        grep "$word" "$room.txt"
    else
        echo "No matches found for '$word' in $room.txt"
    fi
}                                                                                                                                                                                   # Initial menu
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

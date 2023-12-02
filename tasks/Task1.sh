# Initialize variables
guesses=()
hits=0
total=0

# Function to generate a random number between 0 and 9
generate_number() {
    echo $(( RANDOM % 10 ))
}

# Function to print the last 10 numbers with color coding
print_numbers() {
    for ((i=${#guesses[@]}-1; i>=0 && i>=${#guesses[@]}-10; i--)); do
        if [ "${guesses[$i]}" = "hit" ]; then
            echo -ne "\e[32m${numbers[$i]} \e[0m" # Green for hits
        else
            echo -ne "\e[31m${numbers[$i]} \e[0m" # Red for misses
        fi
    done
    echo
}

# Main game loop
while true; do
    random_number=$(generate_number)
    total=$((total + 1))

    echo "Step: $total"
    read -p "Please enter number from 0 to 9 (q - quit): " user_input

    # Check for quit condition
    if [ "$user_input" = "q" ]; then
        echo "Game over."
        break
    fi

    # Validate input
    if ! [[ "$user_input" =~ ^[0-9]$ ]]; then
        echo "Invalid input. Please enter a single digit number."
        total=$((total - 1)) # Adjust total since this attempt is invalid
        continue
    fi

    # Check if the guess is correct
    if [ "$user_input" -eq "$random_number" ]; then
        echo "Hit! My number: $random_number"
        hits=$((hits + 1))
        guesses+=("hit")
    else
        echo "Miss! My number: $random_number"
        guesses+=("miss")
    fi

    numbers+=("$random_number") # Store the generated number

    # Calculate and display statistics
    hit_percent=$(( 100 * hits / total ))
    miss_percent=$(( 100 - hit_percent ))
    echo "Hit: $hit_percent% Miss: $miss_percent%"
    echo -n "Numbers: "
    print_numbers
done

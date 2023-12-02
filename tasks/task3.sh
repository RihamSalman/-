#!/bin/bash

# Initialize and shuffle the board
initialize_board() {
    local i j temp
    board=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 0)

    for ((i = 0; i < 16; i++)); do
        ((j = RANDOM % 16))
        temp=${board[$i]}
        board[$i]=${board[$j]}
        board[$j]=$temp
    done
}

# Print the board
print_board() {
    echo "Move number: $moves"
    for ((i = 0; i < 16; i++)); do
        if ((board[$i] == 0)); then
            echo -n "   "
        else
            printf "%3d" ${board[$i]}
        fi
        ((i % 4 == 3)) && echo
    done
}

# Check if the puzzle is solved
is_solved() {
    for ((i = 0; i < 15; i++)); do
        ((board[$i] != i + 1)) && return 1
    done
    return 0
}

# Get valid moves based on the position of the empty cell
get_valid_moves() {
    local empty_idx=$1
    local valid_moves=()
    # Up
    ((empty_idx > 3)) && valid_moves+=(${board[empty_idx - 4]})
    # Down
    ((empty_idx < 12)) && valid_moves+=(${board[empty_idx + 4]})
    # Left
    ((empty_idx % 4 != 0)) && valid_moves+=(${board[empty_idx - 1]})
    # Right
    ((empty_idx % 4 != 3)) && valid_moves+=(${board[empty_idx + 1]})
    echo ${valid_moves[@]}
}

# Move a tile
move_tile() {
    local tile=$1
    local idx=0 empty_idx=0 valid_moves=()

    for ((i = 0; i < 16; i++)); do
        ((board[$i] == tile)) && idx=$i
        ((board[$i] == 0)) && empty_idx=$i
    done

    valid_moves=($(get_valid_moves $empty_idx))

    if [[ " ${valid_moves[*]} " != *" $tile "* ]]; then
        echo "Wrong move!"
        echo "It is impossible to move domino $tile to an empty cell."
        echo "You can choose: ${valid_moves[*]}"
        return 1
    fi

    # Swap tiles
    board[empty_idx]=$tile
    board[idx]=0
}

# Main game loop
main() {
    initialize_board
    moves=0

    while true; do
        print_board
        is_solved && echo "Congratulations! Puzzle solved in $moves moves." && break
        echo "Your move (q - exit):"
        read -r input
        [[ $input == "q" ]] && break
        if [[ $input =~ ^[1-9]$|^1[0-5]$ ]]; then
            if move_tile $input; then
                ((moves++))
            fi
        else
            echo "Invalid input. Please enter a number between 1 and 15."
        fi
    done
}

main


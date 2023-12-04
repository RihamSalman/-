#!/bin/bash

# Default values
dirpath="."
mask="*"
number=$(nproc) # Number of CPU cores

# Function to parse command-line arguments
parse_arguments() {
    while [[ "$1" != "" ]]; do
        case $1 in
            --path) shift
                    dirpath=$1
                    ;;
            --mask) shift
                    mask=$1
                    ;;
            --number) shift
                      number=$1
                      ;;
            *) command=$1
               ;;
        esac
        shift
    done
}

# Validate arguments and set up environment
setup_environment() {
    # Check if dirpath exists and is a directory
    if [[ ! -d $dirpath ]]; then
        echo "Error: Directory '$dirpath' does not exist."
        exit 1
    fi

    # Check if the mask string is non-empty
    if [[ -z $mask ]]; then
        echo "Error: Mask string cannot be empty."
        exit 1
    fi

    # Check if number is a positive integer
    if ! [[ $number =~ ^[1-9][0-9]*$ ]]; then
        echo "Error: Number must be a positive integer."
        exit 1
    fi

    # Check if command exists and is executable
    if [[ ! -x $command ]]; then
        echo "Error: Command '$command' does not exist or is not executable."
        exit 1
    fi
}

# Process files
process_files() {
    local count=0

    # Find files matching the mask and process them
    find "$dirpath" -maxdepth 1 -type f -name "$mask" | while read -r file; do
        if [[ $count -lt $number ]]; then
            ((count++))
            ( "$command" "$file" & )
        else
            wait -n
            ((count--))
        fi
    done

    # Wait for all processes to finish
    wait
}

# Main function
main() {
    parse_arguments "$@"
    setup_environment
    process_files
}

main "$@"

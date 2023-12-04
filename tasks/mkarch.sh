#!/bin/bash

# Parse command-line arguments
while [[ "$1" != "" ]]; do
    case $1 in
        -d) shift
            dir_path=$1
            ;;
        -n) shift
            name=$1
            ;;
        *) echo "Invalid argument: $1"
           exit 1
           ;;
    esac
    shift
done

# Validate arguments
if [ -z "$dir_path" ] || [ -z "$name" ]; then
    echo "Both dir_path and name are required."
    exit 1
fi

if [ ! -d "$dir_path" ]; then
    echo "Directory $dir_path does not exist."
    exit 1
fi

# Create tar.gz archive
tar czf "$name.tar.gz" -C "$dir_path" .

# Create self-extracting script
cat > "$name" <<EOF
#!/bin/bash

# Parse command-line arguments for extraction
while [[ "\$1" != "" ]]; do
    case \$1 in
        -o) shift
            unpackdir=\$1
            ;;
        *) echo "Invalid argument: \$1"
           exit 1
           ;;
    esac
    shift
done

# Extract the archive
if [ -z "\$unpackdir" ]; then
    unpackdir="."
fi
mkdir -p "\$unpackdir"
tar xzf "\$0.tar.gz" -C "\$unpackdir"

EOF

# Append the archive to the script
cat "$name.tar.gz" >> "$name"

# Set execute permission
chmod +x "$name"

# Clean up the tar.gz file
rm "$name.tar.gz"

echo "Self-extracting script $name has been created."


RECOVER=~/.dotfiles/tools/utils/.recover
RECOVER_DIR=~/.trash

list_files_by_timestamp() {

    declare -a files_with_timestamps
    for file in *; do
        if [[ "$file" =~ -([0-9]+)$ ]]; then
            local timestamp="${BASH_REMATCH[1]}"
            files_with_timestamps+=("$timestamp $file")
        fi
    done

    IFS=$'\n' sorted_files=($(sort -nr <<<"${files_with_timestamps[*]}"))
    unset IFS

    sorted_files_list=()
    for entry in "${sorted_files[@]}"; do
        sorted_files_list+=("${entry#* }")
    done
}

if [ ! -f "$RECOVER" ]; then
    exit 0
fi

if [ $# -ge 1 ]; then
    PTH=$(pwd)
    cd $RECOVER_DIR
    list_files_by_timestamp
    for arg in $@
    do
        for files in ${sorted_files_list[@]}
        do
            file_strip=$(echo $files | sed -r 's/^(.*)-[0-9]+$/\1/')
            if [ $arg = $file_strip ]
            then
                cp -r "$files" "$PTH/$file_strip"
                break
            fi
        done
    done
    exit 0
fi

PTH=$(head -n 1 "$RECOVER")
cd "$RECOVER_DIR"

# Récupère la liste des fichiers à déplacer
files_to_move=$(tail -n 1 "$RECOVER")

for file in $files_to_move
do
    file_strip=$(echo $file | sed -r 's/^"(.*)-[0-9]+"$/\1/')
    eval mv $file "$PTH/$file_strip"
done


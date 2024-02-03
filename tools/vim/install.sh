#!/bin/sh

cd vim

folders=(
    "Vundle.vim,https://github.com/VundleVim/Vundle.vim"
    "coc.nvim,https://github.com/neoclide/coc.nvim"
    "delimitMate,https://github.com/Raimondi/delimitMate"
    "DoxygenToolkit.vim,https://github.com/vim-scripts/DoxygenToolkit.vim"
    "fzf.vim,https://github.com/junegunn/fzf"
    "sensible,https://github.com/tpope/vim-sensible"
    "vim-airline,https://github.com/vim-airline/vim-airline"
)

extract_tuple() {
    local tuple="$1"
    local index="$2"
    local separator=","
    local element=$(echo "$tuple" | cut -d"$separator" -f"$((index + 1))")
    echo "$element"
}

cd .vim/bundle/

for tuple in "${folders[@]}"; do
    name=$(extract_tuple "$tuple" 0)
    path=$(extract_tuple "$tuple" 1)
    if [ ! -d "$name" ]
    then
        (git clone $path $name)
    fi
done

cd coc.nvim
npm ci
cd ..

cd ../../
cp .vimrc ~/
cp .vim ~/ -r 2> /dev/null
cd ..

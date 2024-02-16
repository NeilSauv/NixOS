echo "$(pwd)/" > ~/.dotfiles/tools/utils/.recover
ARGS=""
timestamp=$(date +%s)
for arg in "$@"
do
    strip_arg=$(echo $arg | rev | cut -d '/' -f1 | rev)
    ARGS+="\"$strip_arg-$timestamp\" "
    mv -f "$arg" ~/.trash/"${strip_arg}-$timestamp"
done
echo "$ARGS" >> ~/.dotfiles/tools/utils/.recover

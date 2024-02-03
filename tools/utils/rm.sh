mv -f "$@" ~/.trash
echo "$(pwd)/" > ~/.dotfiles/tools/utils/.recover
ARGS=""
for arg in "$@"
do
  ARGS+="\"$arg\" "
done
echo "$ARGS" >> ~/.dotfiles/tools/utils/.recover

FILE="/tmp/TRASH-$(date +"%Y-%m-%d-%H-%M-%S")/"
mkdir -p "$FILE"
mv ~/.trash/* "$FILE"

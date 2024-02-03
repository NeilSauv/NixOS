cd users/
res=$(ls -d */ 2> /dev/null 1> /dev/null; echo $?)

if [ $res != "0" ]
then
    mkdir "$NAME_USER"
fi

cd ..

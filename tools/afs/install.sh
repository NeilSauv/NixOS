if [ "$NAME_USER" != 'neil' ]
then
    exit 0
fi

kinit -f neil.sauvage@CRI.EPITA.FR
mkdir -p ~/afs
sshfs -o reconnect neil.sauvage@ssh.cri.epita.fr:/afs/cri.epita.fr/user/n/ne/neil.sauvage/u/ ~/afs

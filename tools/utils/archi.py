import os
import sys

def list_files(startpath):
    # Instructions pour ChatGPT
    print("=== Instructions pour ChatGPT ===")
    print("Ce qui suit est une arborescence des répertoires et fichiers du projet, avec le contenu des fichiers inclus.")
    print("Chaque fichier est délimité par une ligne de 80 signes '=' avant et après son contenu.")
    print("Utilisez ces informations pour comprendre la structure et le contenu des fichiers.")
    print("=================================")
    
    # Affichage de l'arborescence des répertoires et fichiers
    for root, dirs, files in os.walk(startpath):
        level = root.replace(startpath, '').count(os.sep)
        indent = ' ' * 4 * (level)
        print('{}{}/'.format(indent, os.path.basename(root)))
        subindent = ' ' * 4 * (level + 1)
        for f in files:
            print('{}{}'.format(subindent, f))
            print('{}{}'.format(subindent, '=' * 80))
            with open(os.path.join(root, f), 'r', errors='ignore') as file:
                content = file.read()
                for line in content.splitlines():
                    print('{}    {}'.format(subindent, line))
            print('{}{}'.format(subindent, '=' * 80))

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python list_files.py <path>")
    else:
        list_files(sys.argv[1])

import xml.etree.ElementTree as ET
import os
import re
import sys

def invert_color(hex_color):
    if hex_color == 'none':
        return 'none'
    
    # Supprimer le # initial si présent
    hex_color = hex_color.lstrip('#')
    # Convertir la couleur hexadécimale en RGB
    rgb = int(hex_color, 16)
    r, g, b = (rgb >> 16) & 0xff, (rgb >> 8) & 0xff, rgb & 0xff
    # Inverser les couleurs
    inverted_rgb = (255 - r, 255 - g, 255 - b)
    # Convertir en hexadécimal
    return '#{:02x}{:02x}{:02x}'.format(*inverted_rgb)

def is_hex_color(color):
    return re.match(r'^#?[0-9a-fA-F]{6}$', color) is not None

def invert_svg_colors(svg_content):
    tree = ET.ElementTree(ET.fromstring(svg_content))
    root = tree.getroot()
    
    # Parcourir tous les éléments
    for element in root.iter():
        # Inverser les couleurs définies dans l'attribut "fill"
        if 'fill' in element.attrib:
            element.attrib['fill'] = invert_color(element.attrib['fill'])
        # Inverser les couleurs définies dans l'attribut "stroke"
        if 'stroke' in element.attrib:
            element.attrib['stroke'] = invert_color(element.attrib['stroke'])
    
    svg_string = ET.tostring(root, encoding='unicode')
    
    # Supprimer les préfixes d'espaces de noms
    svg_string = re.sub(r'\s*ns[0-9]+:', '', svg_string)
    
    return svg_string

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <file1.svg> <file2.svg> ...")
        sys.exit(1)
    
    input_svgs = sys.argv[1:]  # Liste des chemins vers les fichiers SVG d'entrée

    inverted_svgs = {}
    for path in input_svgs:
        with open(path, 'r') as file:
            svg_content = file.read()
            inverted_content = invert_svg_colors(svg_content)
            inverted_svgs[path] = inverted_content

    # Sauvegarder les fichiers SVG modifiés
    for path, content in inverted_svgs.items():
        base, ext = os.path.splitext(path)
        output_path = base + '_white' + ext
        with open(output_path, 'w') as file:
            file.write(content)

    print("Fichiers traités : ", list(inverted_svgs.keys()))

#!/bin/python3

import argparse
import sys
import shutil
import os
import os.path
import yaml
import subprocess as sp
from PIL import Image
from lxml import etree as ET

CWD = os.getcwd()

IMG_DIR = "/share/backgrounds/%s"
IMG_PATH = IMG_DIR + "/%s.png"
IMG_XML_PATH = IMG_DIR + "/%s.xml"
XML_DIR = "/share/background-properties"
XML_PATH = XML_DIR + "/%s.xml"

GNOME_XML_DIR = "/share/gnome-background-properties"
GNOME_XML_PATH = GNOME_XML_DIR + "/%s.xml"

MATE_XML_DIR = "/share/mate-background-properties"
MATE_XML_PATH = MATE_XML_DIR + "/%s.xml"

XFCE_IMG_DIR = "/share/backgrounds/xfce"
XFCE_IMG_PATH = XFCE_IMG_DIR + "/%s.png"

KDE_PATH = "/share/wallpapers/%s"
KDE_IMG_PATH = KDE_PATH + "/contents/images/%s.png"

RATIOS = {
        "1-1": ["4096x4096", "2048x2048"],
        "3-2": ["1152x768", "1280x854", "1440x960", "2160x1440", "3000x2000", "4500x3000"],
        "4-3": ["800x600", "1024x768", "1280x960", "1600x1200", "2048x1536"],
        "5-4": ["1280x1024", "2560x2048", "5120x4096"],
        "16-10": ["1280x800", "1440x900", "1680×1050", "1920×1200", "2560×1600"],
        "16-9": ["1366x768", "1600x900", "1920x1080", "2880x1800", "3840x2160"],
        "21-9": ["2520x1080," "3360x1440"]
        }

SERIES = ["Campanula", "Campanula Alt", "Campanula Wireframe"]

AUTHOR = "Tianhao Chai <cth451@gmail.com>"

with open("desktop.in", "rt") as f:
    DESKTOP_IN = f.read()


def copy(src, dst):
    shutil.copyfile(src, dst)


def ln(link, target):
    try:
        os.symlink(target, link)
    except FileExistsError as e:
        os.remove(link)
        os.symlink(target, link)


def mkdir(path):
    print("mkdir " + path)
    os.makedirs(path, mode=0o755, exist_ok=True)


def normalize(title):
    return title.replace("\'", "").replace(" ", "-").lower()


# This generates an XML at dest/prefix/background-properties/series.xml with
# hint to another XML with a full list of different images intended for various
# aspect ratios (handled by gen_images_xml)
# 
# Plus symlinks to it in dest/prefix/
def gen_xml(series, dest, prefix):
    fname = normalize(series)
    xml_path = (prefix + XML_PATH) % fname
    img_xml_path = (prefix + IMG_XML_PATH) % (fname, fname)
    gnome_xml_path = (prefix + GNOME_XML_PATH) % fname
    mate_xml_path = (prefix + MATE_XML_PATH) % fname

    root = ET.Element("wallpapers")
    wp = ET.SubElement(root, "wallpaper", {"delete":"false"})
    ET.SubElement(wp, "name").text = series
    ET.SubElement(wp, "filename").text = img_xml_path
    ET.SubElement(wp, "artist").text = AUTHOR
    ET.SubElement(wp, "options").text = "zoom"

    tree = ET.ElementTree(root)
    tree.write(dest + xml_path, encoding="UTF-8", pretty_print=True, xml_declaration=True, doctype='<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">')
    # Create XML links for Gnome and Mate
    ln(dest + gnome_xml_path, xml_path)
    ln(dest + mate_xml_path, xml_path)


def gen_img_xml(series, dest, prefix):
    fname = normalize(series)
    root = ET.Element("background")
    static = ET.SubElement(root, "static")
    file = ET.SubElement(static, "file")

    for key in RATIOS:
        src_img = "rendered/" + key + "/" + fname + "-" + key + ".png"
        dest_img = IMG_PATH % (fname, fname + "-" + key)
        with Image.open(src_img) as im:
            width, height = im.size
        size = ET.SubElement(file, "size", {"width": "%i" % width, "height": "%i" % height})
        size.text = dest_img

    tree = ET.ElementTree(root)
    tree.write(dest + prefix + IMG_XML_PATH % (fname, fname), encoding="UTF-8", pretty_print=True)

def proc_series(series, dest, prefix):
    fname = normalize(series)

    # Path to symlinks
    kde_path = (prefix + KDE_PATH) % fname

    # Meta data content
    desktop_content = DESKTOP_IN.replace("%TITLE%", series) \
            .replace("%FNAME%", fname)

    # Install directories
    mkdir(dest + prefix + IMG_DIR % fname)
    mkdir(dest + kde_path + "/contents/images")

    # Install base images, xmls
    for key in RATIOS:
        src_img = "rendered/" + key + "/" + fname + "-" + key + ".png"
        dest_img = prefix + IMG_PATH % (fname, fname + "-" + key)
        copy(src_img, dest + dest_img)
        # Install image symlinks for xfce
        ln(dest + prefix + XFCE_IMG_PATH % (fname + "-" + key), dest_img)
        # Install image symlinks for KDE
        for reso in RATIOS[key]:
            ln(dest + prefix + KDE_IMG_PATH % (fname, reso), dest_img)

    gen_xml(series, dest, prefix)
    gen_img_xml(series, dest, prefix)

    # Handle KDE
    # Install desktop file and data structure
    with open(dest + kde_path + "/metadata.desktop", "w") as f:
        f.write(desktop_content)

    # KDE wants a thumbnail or "screenshot" at /contents/screenshot.png
    square_img = "rendered/1-1/" + fname + "-1-1.png"
    sp.run(["convert", square_img, "-resize", "500x500", dest + kde_path + "/contents/screenshot.png"])

def __main__():
    parser = argparse.ArgumentParser(description='Generate data')
    parser.add_argument('--output', '-o', default=".", help="Dest DIR")
    parser.add_argument('--prefix', '-p', default="/usr", help="Prefix DIR")
    arg = parser.parse_args()

    DEST = arg.output
    PREFIX = arg.prefix

    mkdir(DEST + PREFIX + XML_DIR)
    mkdir(DEST + PREFIX + GNOME_XML_DIR)
    mkdir(DEST + PREFIX + MATE_XML_DIR)
    mkdir(DEST + PREFIX + XFCE_IMG_DIR)
    for series in SERIES:
        proc_series(series, DEST, PREFIX)

if __name__ == "__main__":
    __main__()

# vim: set tabstop=4 expandtab :

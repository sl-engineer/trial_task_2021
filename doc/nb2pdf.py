#!/user/bin/env python3
# coding:utf-8

"""
Script to convert Jupyter Notebook to fancy looking PDF.
Creates PDF with same name in the same directory. Example:
    python3 nb2pdf path_to/notebook.ipynb
"""
import os
import sys
import shutil


def convert(path):
    # get notebook name without extension
    ipynb_name = os.path.splitext(os.path.basename(path))[0]
    # ipynb to markdown
    os.system("jupyter nbconvert --no-input --to markdown %s.ipynb" % ipynb_name)
    # markdown to pdf
    os.system("pandoc --toc --filter pandoc-svg.py -V lang=ru --pdf-engine=xelatex -fmarkdown-implicit_figures -o {0}.pdf {0}.md".format(ipynb_name))
    # remove artifacts
    shutil.rmtree(ipynb_name + '_files')
    os.remove(ipynb_name + '.md')


if __name__ == "__main__":
    try:
        ipynb_path = sys.argv[1]
    except IndexError:
        print("Path to the notebook file must be provided!")
        exit()
    convert(ipynb_path)

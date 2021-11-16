---
title: |
       | Trial cross-bar controller
       | Device guide
author: Viacheslav Tarasov
date: \today
toc: true
numbersections: true
geometry: margin=2.5cm
urlcolor: blue
header-includes: |
    \usepackage{fancyhdr}
    \pagestyle{fancy}
    \newfontfamily\cyrillicfont{Liberation Serif}
    \newfontfamily{\cyrillicfonttt}{Courier New}
include-before:
    '`\newpage{}`{=latex}'    
---
\newpage{}
# Рабочее окружение

Описание всех основных директорий рабочего окружения.

## doc

Директория с исходниками документации.

* dev_guide - директория с LaTeX версией руководства разработчика;
* dev_guide_img - директория с изображениями для руководства разработчика;
* dev_guide.ipynb - файл Jupyter Notebook с исходным текстом руководства разработчика;
* dev_guide.pdf - руководство разработчика, сохраненное в PDF формате;
* nb2pdf.py - python скрипт для преобразования Jupyter Notebook в PDF;
* pandoc-svg.py - фильтр для Pandoc; используется при приобразовании в PDF; заставляет использовать Inkscape для преобразования SVG файлов, чтобы избежать артефактов отображения в PDF;

## rtl

Директория с исходниками контроллера.


## sim

Содержит скрипты для запуска симуляции в Xcelium.

* run_xm - скрипт запуска симуляции (./run_xm -h для подробностей);
* src.files - файл со списком всех исходников для симуляции;

## syn

Директория со скриптами запуска синтеза в Genus. Используется для оценки временных/пространственных параметров блоков.


## tb

Директория с тестбенчами.

* dev - рабочий тестбенч; используется при разработке контроллера;


\newpage{}

# Архитектура

## Описание портов

## Тактирование и сброс

* Разделение на тактовые домены внутри не предусмотрено. 
* Для всех триггеров внутри контроллера используется асинхронный сброс с активным нулём.

## Описание модулей

\newpage{}

# Функционирование

\newpage{}


    ---------------------------------------------------------------------------

    FileNotFoundError                         Traceback (most recent call last)

    <ipython-input-3-56cd6aac7ad6> in <module>
          1 import nb2pdf
    ----> 2 nb2pdf.convert('dev_guide.ipynb')
    

    /mnt/hgfs/WorkSpace/trial_task_2021/doc/nb2pdf.py in convert(path)
         20     os.system("pandoc --toc --filter pandoc-svg.py -V lang=ru --pdf-engine=xelatex -fmarkdown-implicit_figures -o {0}.pdf {0}.md".format(ipynb_name))
         21     # remove artifacts
    ---> 22     shutil.rmtree(ipynb_name + '_files')
         23     os.remove(ipynb_name + '.md')
         24 


    /usr/lib/python3.8/shutil.py in rmtree(path, ignore_errors, onerror)
        707             orig_st = os.lstat(path)
        708         except Exception:
    --> 709             onerror(os.lstat, path, sys.exc_info())
        710             return
        711         try:


    /usr/lib/python3.8/shutil.py in rmtree(path, ignore_errors, onerror)
        705         # lstat()/open()/fstat() trick.
        706         try:
    --> 707             orig_st = os.lstat(path)
        708         except Exception:
        709             onerror(os.lstat, path, sys.exc_info())


    FileNotFoundError: [Errno 2] No such file or directory: 'dev_guide_files'


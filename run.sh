#!/bin/bash

# 1. Verifica se o argumento (nome do arquivo) foi fornecido
if [ -z "$1" ]; then
    echo "Error: No file was given."
    echo "Usage: $0 <arquivo> [usar_biber: true/false] [usar_makeindex: true/false]"
    exit 1
fi

NAME="${1%.tex}"

# 2. Função auxiliar para ler valores booleanos flexíveis (1, true, yes, sim, s, y)
is_true() {
    [[ "${1,,}" =~ ^(true|1|yes|y|sim|s)$ ]]
}

RUN_BIBER=false
if is_true "$2"; then
    RUN_BIBER=true
fi

RUN_MAKEINDEX=false
if is_true "$3"; then
    RUN_MAKEINDEX=true
fi

# 3. Verifica se o arquivo existe
if [ ! -f "$NAME.tex" ]; then
    echo "Error: The file '$NAME.tex' was not find."
    exit 1
fi


if ! lualatex -interaction=nonstopmode "$NAME.tex"; then
    echo "Critical error at compilation."
    exit 1
fi

if [ "$RUN_BIBER" = true ]; then
    if [ -f "$NAME.bcf" ]; then
        biber "$NAME" || echo "Warning: Error at Biber."
    else
        echo ">>> Warning: Biber was required, but the file $NAME.bcf was not found."
    fi
fi

if [ "$RUN_MAKEINDEX" = true ]; then
    if [ -f "$NAME.idx" ]; then
        makeindex "$NAME.idx" || echo "Warning: Error at Makeindex."
    else
        echo ">>> Aviso: Makeindex was required, but the file $NAME.idx was not found."
    fi
fi

lualatex -interaction=nonstopmode "$NAME.tex"

if [ "$RUN_BIBER" = true ] || [ "$RUN_MAKEINDEX" = true ]; then
    lualatex -interaction=nonstopmode "$NAME.tex"
fi

if [ ! -f "$NAME.pdf" ]; then
    echo " Error: the file $NAME.pdf was not generated."
    exit 1
fi

# rm $NAME.aux
#rm $NAME.bbl
#rm $NAME.bcf
#rm $NAME.blg
#rm $NAME.idx
#rm $NAME.ilg
#rm $NAME.ind
#rm $NAME.log
#rm $NAME.lol
#rm $NAME.out
#rm $NAME.pdf
#rm $NAME.run.xml
#rm $NAME.sig.lua
#rm $NAME.toc



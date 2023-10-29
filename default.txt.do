exec >&2

MSG=$(basename $2)
INPUT=html/$MSG.html

redo-ifchange $INPUT

pandoc --from html --to plain $INPUT > $3

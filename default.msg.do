exec >&2

MSG=$(basename $2)
INPUT=$(find maildir -type f -name $MSG\*)

redo-ifchange $INPUT

cat $INPUT > $3


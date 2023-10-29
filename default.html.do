exec >&2

MSG=$(basename $2)
INPUT=messages/$MSG.msg

redo-ifchange $INPUT

awk 'BEGIN { output = 0; } /^$/ { output = 1; next } output { print }' $INPUT | base64 -d > $3

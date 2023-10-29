find maildir -type f | parallel redo-ifchange parsed/{/.}.txt

redo-ifchange errors.txt
redo-ifchange errors-by-facility.txt

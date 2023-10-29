find maildir -type f ! -name \.gitkeep | parallel redo-ifchange parsed/{/.}.txt

redo-ifchange errors.txt
redo-ifchange errors-by-facility.csv
redo-ifchange error-details.csv

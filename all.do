find maildir -type f | parallel redo-ifchange parsed/{/.}.txt

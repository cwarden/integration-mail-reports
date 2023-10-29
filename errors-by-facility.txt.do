exec >&2

redo-ifchange parsed/*.txt

grep -Eh '(Message |Originating)' parsed/* | \
	perl -pe 's/Message Type/Message_Type/g; s/Originating Facility/Originating_Facility/g;' |
	awk '
		{ $1 = ""}
		{
			if (NR % 3 == 0) {
				print $0
			} else {
				printf "%s ", $0
			}
		}' | \
	perl -pe '
		s/\d{4}-\d{3}-\d+-\d+/____-___-_-_____/g;
		s/\d{4}-\d+-\d+/____-___-_/g;
		s/\d{4}-\d+/____-___/g;
		s/0Sq\w+/0Sq______________/g;
		s/Race: bad value for restricted picklist field: ./Race: bad value for restricted picklist field: _/g;
		s/conn=STANDARD:1:1:\d+:1/conn=STANDARD:1:1:_____:1/g;' | \
		sort | uniq -c | sort -nr > $3

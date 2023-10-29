exec >&2

redo-ifchange parsed/*.txt

grep -Eh '(Message |Originating)' parsed/* | \
	perl -pe 's/Message Type/Message_Type/g; s/Originating Facility/Originating_Facility/g;' |
	goawk -o csv '
		BEGIN {
			MessageType["A01"] = "Admit"
			MessageType["A02"] = "Transfer a Patient"
			MessageType["A03"] = "Discharge"
			MessageType["A04"] = "Register a Patient"
			MessageType["A05"] = "Pre-admit"
			MessageType["A08"] = "Update Patient Information"
			MessageType["A11"] = "Cancel Admit"
			MessageType["A13"] = "Cancel Discharge"
			MessageType["A28"] = "Add Person Information"
			MessageType["A31"] = "Update Person Information"
		}

		$1 == "Message_Type" { msgType = sprintf("%s (%s)", $2, MessageType[$2]); next }
		$1 == "Originating_Facility" { originatingFacility = substr($0, index($0, $2)); next }
		NR % 3 == 0 { msg = substr($0, index($0, $2)); print msgType, originatingFacility, msg; }' | \
	perl -pe '
		s/\d{4}-\d{3}-\d+-\d+/____-___-_-_____/g;
		s/\d{4}-\d+-\d+/____-___-_/g;
		s/\d{4}-\d+/____-___/g;
		s/0Sq\w+/0Sq______________/g;
		s/Race: bad value for restricted picklist field: ./Race: bad value for restricted picklist field: _/g;
		s/conn=STANDARD:1:1:\d+:1/conn=STANDARD:1:1:_____:1/g;' | \
		sort | uniq -c | sort -nr | \
		perl -pe 's/^\s+(\d+)\s+/\1,/' | \
		goawk -i csv -o csv 'BEGIN { print "Count", "Message Type", "Facility", "Error" } { print }' > $3

exec >&2

redo-ifchange parsed/*.txt

grep -Eh '(Message |Originating|Transaction Identifier|Timestamp)' parsed/* | \
	perl -pe '
		s/Message Type/Message_Type/g;
		s/Transaction Identifier/Transaction_Identifier/g;
		s/Originating Facility/Originating_Facility/g;' |
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

		$1 == "Message_Type" { msgType = sprintf("%s (%s)", $2, MessageType[$2])}
		$1 == "Timestamp" { timestamp = $2;}
		$1 == "Originating_Facility" { originatingFacility = substr($0, index($0, $2))}
		$1 == "Message" { msg = substr($0, index($0, $2))}
		$1 == "Transaction_Identifier" { txId = $2}
		NR %5 != 0 { next; }
		{ print timestamp, msgType, originatingFacility, txId, msg; }' | \
		goawk -i csv -o csv 'BEGIN { print "Timestamp", "Message Type", "Facility", "Transaction Id", "Error" } { print }' > $3

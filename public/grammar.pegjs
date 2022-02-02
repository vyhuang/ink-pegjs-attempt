Ink
  = (Choice+ / PlainProse)*EOF

Choice
	= (whitespace)*sym:(choiceSymbol)str:(PlainProse) {
		if (sym === '+')
		{
			return `SINGLE_CHOICE(${str})`
		}
		else
		{
			return `CHOICE(${str})`
		}
	}

PlainProse
	= lines:(PlainLine)+ {return `PROSE(${lines})`}

PlainLine
	= (whitespace)*&[^+*](TextString)(LineTerminator)* {return `LINE(${text()})`}

TextString
	= chars:TextCharacter+ { return chars.join("")}

TextCharacter
  = [^\n\r\\#]
	/ "\\" char:[\\#] { return char}

choiceSymbol
	= "*" / "+"

gatherSymbol
	= "-"

whitespace
	= " "
	/ "\t"
	/ "\v"
	/ "\f"
	/ "\u00A0"
	/ "\uFEFF"

LineTerminator
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028"
  / "\u2029"

EOF
  = !.
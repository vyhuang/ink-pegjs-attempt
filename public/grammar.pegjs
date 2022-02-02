Ink
  = (Knot / Choice / PlainProse / DivertLine)*EOF

Choice
	= (wSpace)*sym:(choiceSymbol)str:(PlainProse) {
		if (sym === '+')
		{ return `SINGLE_CHOICE(${str})\n`; }
		else
		{ return `CHOICE(${str})\n`; }
	}

PlainProse
	= lines:(PlainLine)+ {return `PROSE(\n\t${lines})\n`; }

PlainLine
	= wSpace* &[^*+] !("==" "="*) TextString divert:Divert? LineTerminator* {
		return `LINE(${text().split("->")[0].trim()})${divert || ""}`; 
	}

TextString
	= chars:(!"->" TextCharacter)+ { return chars.join(""); }

TextCharacter
  = [^\n\r\\#] / "\\" char:[\\#] { return char; }

Knot
	=	"==""="* wSpace* knot_label:validIdentifier wSpace* "="* LineTerminator+ {
		return `KNOT(${knot_label})\n`;
	}

DivertLine
	= Divert LineTerminator*

Divert
	= wSpace* "->" wSpace* divert_label:validIdentifier {
		return `DIVERT(${divert_label})`;
	}

choiceSymbol
	= "*" / "+"

divertSequence
  = "->"

gatherSymbol
	= "-"

//Identifier can't start with a number…
indentifierBeginCharacter
	= [a-zA-Z_\u0100-\u017F\u0180-\u024F\u0600-\u06FF\u0530-\u058F\u0400-\u04FF\u0370-\u03FF\u0590-\u05FF]
//Identifier characters can anything within these unicode blocks
indentifierCharacter
	= [a-zA-Z0-9_\u0100-\u017F\u0180-\u024F\u0600-\u06FF\u0530-\u058F\u0400-\u04FF\u0370-\u03FF\u0590-\u05FF]
anyNonIdentifierCharacter
	= [^a-zA-Z_\u0100-\u017F\u0180-\u024F\u0600-\u06FF\u0530-\u058F\u0400-\u04FF\u0370-\u03FF\u0590-\u05FF]
validIdentifier
	= char:indentifierBeginCharacter chars:indentifierCharacter* {return char+chars.join(""); }

standardFunctions
	= 'LIST_COUNT|LIST_MIN|LIST_MAX|LIST_ALL|LIST_INVERT|LIST_RANDOM|CHOICE_COUNT|TURNS_SINCE|LIST_RANGE|TURNS|POW|FLOOR|CEILING|INT|FLOAT'

wSpace
	= " " / "\t" / "\v" / "\f" / "\u00A0" / "\uFEFF"

LineTerminator
  = "\n" / "\r\n" / "\r" / "\u2028" / "\u2029"

EOF
  = !.
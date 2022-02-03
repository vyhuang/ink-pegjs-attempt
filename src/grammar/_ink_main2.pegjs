
// Corresponds to InkParser.cs
Story
	= ContentList / Newlines? EOF

// Corresponds somewhat to InkParser_Content.cs
// TODO: flesh out choice & string parsing
ContentList
	= Choice 
	/ Divert
	/ lines:(PlainContentLine Newlines?)+ { return { type:'contentlist', value: lines }; }

ChoiceMixedTextAndLogic
	=  chars:ChoiceContentCharacter+ /*TODO: (ContentText InlineLogicOrGlue / ContentText / InlineLogicOrGlue)+ */ {
		return { type: "text", value: chars.join("") };
	}

PlainContentLine
	= text:PlainContentText divert:(Whitespace @Divert)? /*/ ThreadArrow / */ Whitespace &EOL /* / Glue */ {
		return [text, divert];
	}

PlainContentText
	= chars:PlainContentCharacter+ {
		return { type: "text", value: chars.join("") };
	}

ChoiceContentCharacter
	= !"->" ("\\" @(_invalidTextCharacter / [\[\]])) / (_validTextCharacterChoice)
StringContentCharacter
	= "\\" @(_invalidTextCharacter / "\"") / _validTextCharacterString
PlainContentCharacter
	= !"->" char:("\\" @_invalidTextCharacter / @_validTextCharacter) { return char; }

_validTextCharacterChoice = [^{}|\n\r\\\#\[\]]
_validTextCharacterString = [^{}|\n\r\\\#\"]
_validTextCharacter = [^{}|\n\r\\#] 
_invalidTextCharacter = [{}|\n\r\\#] 

// TODO: Corresponds to InkParser_Choices.cs
Choice
	= Whitespace choiceSymbol:("*" / "+") 
			name:(Whitespace @BracketedName)?
			/*condition:(Whitespace ChoiceCondition )?*/
			startContent:(Whitespace @ChoiceMixedTextAndLogic)?
			optionOnlyContent:(Whitespace hasBrackets:"[" @ChoiceMixedTextAndLogic "]")?
			innerContent:(Whitespace @ChoiceMixedTextAndLogic)?
			postContent:( 
				divert:(&{ startContent || optionOnlyContent || innerContent } Whitespace @Divert)
				/ fallbackInnerContent:(Whitespace "->" Whitespace @ChoiceMixedTextAndLogic )
			{ return { divert, fallbackInnerContent }; })?
			tags:(Whitespace /* Tags */ )?
			fallbackDivert:(Whitespace @Divert)?
			EOL {
				// TODO: uncomment condition line and remove following value set
				const condition = null;
				let finalInnerContent = [innerContent];
				let finalDivert;
				if (postContent !== null) {
					finalInnerContent = postContent.fallbackInnerContent || null;
					finalDivert = postContent.divert || null;
				}
				finalDivert = postContent || fallbackDivert;
				if (finalDivert !== null) {
					finalInnerContent.push(finalDivert);
				}
				return {
					startContent,
					optionOnlyContent,
					finalInnerContent,
					identifier: name,
					// indentationDepth,
					hasWeaveStyleInlineBrackets: optionOnlyContent !== null && optionOnlyContent.hasBrackets !== undefined,
					condition,
					onceOnly: choiceSymbol === '*',
					isInvisibleDefault: postContent !== null && postContent.fallbackInnerContent !== undefined
				};
			}

BracketedName
	= "(" Whitespace name:validIdentifier Whitespace")" { return name; }


// TODO: Corresponds to InkParser_Divert.cs
// TODO: Support thread syntax
// TODO: Support divert arguments
Divert
	= "->" path:(Whitespace @DotSeparatedDivertPathComponents) {
		return { type: "divert", targetPath: path }
	}

DotSeparatedDivertPathComponents
	= chars:(@validIdentifier ".")* char:validIdentifier {
		return `${chars.join(".")}${chars.length > 0 ? "." : ""}${char}`;
	}

// TODO: Corresponds to InkParser_Knot.cs

// TODO: Corresponds to CommentEliminator.cs
// TODO: Corresponds to InkParser_Tags.cs

// TODO: Corresponds to InkParser_Expressions.cs

// TODO: Corresponds to InkParser_Logic.cs

// TODO: Corresponds to InkParser_Conditional.cs

// TODO: Corresponds to InkParser_Statements.cs

// Corresponds somewhat to InkParser_CharacterRanges.cs
// Heavily referenced from the 'inkle/ink-tmlanguage' repository.
// TODO: check the character sets to make sure they match the actual C# file.
validIdentifier
	= char:indentifierBeginCharacter chars:indentifierCharacter* { return char + chars.join(""); }

indentifierBeginCharacter
	= [a-zA-Z_\u0100-\u017F\u0180-\u024F\u0600-\u06FF\u0530-\u058F\u0400-\u04FF\u0370-\u03FF\u0590-\u05FF]
indentifierCharacter
	= [a-zA-Z0-9_\u0100-\u017F\u0180-\u024F\u0600-\u06FF\u0530-\u058F\u0400-\u04FF\u0370-\u03FF\u0590-\u05FF]
anyNonIdentifierCharacter
	= [^a-zA-Z_\u0100-\u017F\u0180-\u024F\u0600-\u06FF\u0530-\u058F\u0400-\u04FF\u0370-\u03FF\u0590-\u05FF]

// Corresponds to InkParser_Whitespace.cs
EOL = EOF / Newline
Newlines = newlines:Newline+ { return { type: "newline", num: newlines.length }; }
Newline = Whitespace ("\r\n" / "\n") 
Whitespace = WhitespaceChar*
WhitespaceChar = [ \t]
EOF = !. { return { type: "EOF" }; }

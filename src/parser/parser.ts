import pegjs, { Parser } from "pegjs";

let parser: Parser | undefined;

async function parse(str : string | null) {
	if (parser === undefined)
	{
		const grammar = 
			await fetch('grammar.pegjs').then((response) => response.text());
		parser = pegjs.generate(grammar);
	}

	if (str === null)
	{
		return '';
	}
	return parser.parse(str);
}
export default parse;
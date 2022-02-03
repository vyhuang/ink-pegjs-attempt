import peggy, { Parser } from "peggy";
import grammar from '../grammar/_ink_main2.pegjs?raw';

const startRule = "Story";
let parser: Parser | undefined;

async function parse(str : string | null) {
	if (parser === undefined)
	{
		parser = peggy.generate(grammar);
	}

	if (str === null)
	{
		return '';
	}
	return parser.parse(str, { startRule });
}
export default parse;
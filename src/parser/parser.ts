import pegjs from "pegjs";

function parse(str : string | null) {
	if (str === null)
	{
		return '';
	}
	return str.toLocaleUpperCase();
}
export default parse;
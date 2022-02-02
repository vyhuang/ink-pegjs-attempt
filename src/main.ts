import './style.css';
import parse from './parser/parser';

const parsedTextField = document.getElementById("parsed-text");
const errorField = document.getElementById("error-message");

fetch('test.txt').then(response => {
	return response.text();
}).then(data => {
	const textToParse = document.getElementById("text-to-parse");
	if (textToParse !== null)
		textToParse.textContent = data;
	textToParse?.addEventListener('input', updateText);

	parse(data).then(parseHandler, parseErrorHandler);
});

function updateText (this: HTMLInputElement, e : Event) {
	parse(this.value).then(parseHandler, parseErrorHandler);
}

function parseHandler(textContent: string) {
	if (parsedTextField !== null)
	{
		parsedTextField.textContent = textContent; 
	}
	if (errorField !== null)
	{
		errorField.textContent = '';
	}
}

function parseErrorHandler(error: any) {
	console.log(error);
	if (errorField !== null)
	{
		let htmlErrorString = "";
		if (error.location !== undefined && error.location.start != undefined)
		{
			htmlErrorString += 
				`<div>Error found in line ${error.location.start.line}, column ${error.location.start.column}:</div>`
		}
		htmlErrorString += `<div>${error.message}</div>`;
		errorField.innerHTML = htmlErrorString;
	}
	if (parsedTextField !== null)
	{
		parsedTextField.textContent = ''; 
	}
}


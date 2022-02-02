import './style.css';
import parse from './parser/parser';

const parsedTextField = document.getElementById("parsed-text");
const errorField = document.getElementById("error-message");

fetch('test-sentence.txt').then(response => {
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
	if (errorField !== null)
	{
		errorField.innerHTML = 
			`<div>Error found at ${error.location}</div>
			<div>${error.message}</div>`;
	}
	if (parsedTextField !== null)
	{
		parsedTextField.textContent = ''; 
	}
}


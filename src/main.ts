import './style.css';
import parse from './parser/parser';
import { EditorState, EditorView, basicSetup } from '@codemirror/basic-setup';
import { lineNumbers } from '@codemirror/gutter';
import { ViewUpdate } from '@codemirror/view';

const errorField = document.getElementById("error-message")!;
const parsedTextField = document.getElementById("parsed-text")!;
const textToParse = document.getElementById("text-to-parse")!;

let editorView = new EditorView({
	state: EditorState.create({
		extensions: [
			basicSetup, 
			lineNumbers(),
			EditorView.updateListener.of(updateText),
			EditorView.lineWrapping
		]
	}),
	parent: textToParse
});


fetch('test.txt').then(response => {
	return response.text();
}).then(data => {
	// insert the initial data into the editor.
	editorView.dispatch({
		changes: {
			from: 0,
			insert: data
		}
	});
	// Then parse the initial data and update the
	// right column with the result.
	parse(data).then(parseHandler, parseErrorHandler);
});

function updateText (update: ViewUpdate) {
	console.log("calling updateText");
	parse(update.view.state.doc.toString())
		.then(parseHandler, parseErrorHandler);
}

function parseHandler(textContent: string) {
	parsedTextField.innerText = textContent;
	parsedTextField.style.backgroundColor = "powderblue";
}

function parseErrorHandler(error: any) {
	console.log(error);
	let htmlErrorString = "";
	if (error.location !== undefined && error.location.start != undefined)
	{
		htmlErrorString += 
			htmlErrorString += 
		htmlErrorString += 
			`<div>Error found in line ${error.location.start.line}, column ${error.location.start.column}:</div>`
	}
	htmlErrorString += `<div>${error.message}</div>`;
	parsedTextField.innerHTML = htmlErrorString;
	parsedTextField.style.backgroundColor = "palevioletred";
}


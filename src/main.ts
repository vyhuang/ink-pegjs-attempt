import './style.css';
import parse from './parser/parser';
import { EditorState, EditorView, basicSetup } from '@codemirror/basic-setup';
import { lineNumbers } from '@codemirror/gutter';
import { ViewUpdate } from '@codemirror/view';

const testFile = 'test-choice.txt'

// Get handles on all the fields on the page.
const errorField = document.getElementById("error-message")!;
const parsedTextField = document.getElementById("parsed-text")!;
const textToParse = document.getElementById("text-to-parse")!;

// Set up CodeMirror to:
// - have line numbers
// - wrap any overflowing lines
// - call updateText() whenever the content inside the editor changes
// - attach as a child to the HTML element 'textToParse'
let editorView = new EditorView({
	state: EditorState.create({
		extensions: [
			basicSetup, 
			lineNumbers(),
			EditorView.lineWrapping,
			EditorView.updateListener.of(updateText)
		]
	}),
	parent: textToParse
});


fetch(testFile).then(response => {
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

function parseHandler(output: any) {
	const textContent = JSON.stringify(output);
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


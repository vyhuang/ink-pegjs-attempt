This is an attempt to implement the compiler for Inkle's ink scripting language using the PegJS library. The grammar definition is contained in 'src/grammar/ink.pegjs'.

If you would like to check the work out, simply clone the repository, run `npm install` in the root directory, then `npm run dev`. This will start up a local dev server with a web page that looks like this:
![](test_page.PNG)

The parser will automatically re-parse the contents of the input field when any changes are made. If the parser runs into an error while attempting to do so, the offending line & column will be listed, along with an appropriate error message.

In order to re-compile the parser after making changes to the grammar file, reload the page. The parser will _not_ be recompiled automatically.

The [ink-tmlanguage](https://github.com/inkle/ink-tmlanguage) Github repository was used as a reference.
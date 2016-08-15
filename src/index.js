require( './main.scss' );

var Program = require( './Main' );
var mainElement = document.getElementById( 'main' );

mainElement.innerHTML = '';

Program.Main.embed(mainElement);
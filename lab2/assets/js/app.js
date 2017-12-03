// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"
import $ from "jquery"
$(document).ready(function(){
	$(".table_sel").click(function() {
		let ex = document.getElementById("stupid-form")
		if(ex == null){
			let template = `<form id="stupid-form">Input <input type="radio" name="choose" id="input-radio" value="Input" checked/><br>Search <input type="radio" name="choose" id="search-radio" value="Search"/></form>`
			$(".table_sel").after(template)
		}
		let sel = $(".table_sel").val()
		switch(sel){
			case "authors":
					$("div").remove("#1, #2, #3, #4")
					let txt1 = $(`<div id="1">Name <input id="author-name" type="text" class="input"></div>`)
					let txt2 = $(`<div id="2">Surname <input id="author-surname" type="text" class="input"></div>`)
					let txt3 = $(`<div id="3">Birth <input id="author-birth" type="text" class="input"></div>`)
					let txt4 = $(`<div id="4">Rating <input id="author-rating" type="text" class="input"></div>`)
					$("#submit").before(txt1,txt2,txt3,txt4)
				break;
			case "genres":
					$("div").remove("#1, #2, #3, #4")
					let txt5 = $(`<div id="1">Name <input id="genre-name" type="text" class="input"></div>`)
					let txt6 = $(`<div id="2">Description <input id="genre-description" type="text" class="input"></div>`)
					$("#submit").before(txt5,txt6)
				break;
			case "mangas":
					$("div").remove("#1, #2, #3, #4")
					let txt7 = $(`<div id="1">Score <input id="manga-input" type="text" class="input"></div>`)
					$("#submit").before(txt7)
				break;
			case "publishers":
					$("div").remove("#1, #2, #3, #4")
					let txt8 = $(`<div id="1">Name <input id="publisher-name" type="text" class="input"></div>`)
					let txt9 = $(`<div id="2">City <input id="publisher-city" type="text" class="input"></div>`)
					let txt10 = $(`<div id="3">Country <input id="publisher-country" type="text" class="input"></div>`)
					let txt11 = $(`<div id="4">Rating <input id="publisher-rating" type="text" class="input"></div>`)
					$("#submit").before(txt8,txt9,txt10,txt11)
				break;
		}
	})
	$("input[name='choose']").click(function(){
		let sel = $(".table_sel").val()
		console.log(val)
		if(sel == "mangas"){
			$("#ch_form").remove("#div-author,#div-genre,#div-publisher")
		}
	})
})
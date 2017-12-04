// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("lab2:lobby", {})
let dropdown = $('#choose')
let form = document.getElementById("ch_form")
let choose = document.getElementById("stupid-form")
let sub = document.getElementById("submit")
let submit = $('#submit')

//dropdown.focus()

dropdown.on('click', event => {
	try{
	let one = document.getElementById("div-author")
	let two = document.getElementById("div-genre")
	let three = document.getElementById("div-publisher")
	one.remove()
	two.remove()
	three.remove()}
	catch(e){
		console.log(e)
	}
	if(dropdown.val() == "mangas"){
		channel.push('get:tables', {message: dropdown.val(),user: "root"})
	}
})

channel.on('tables:answer', payload =>{
	if(!document.getElementById('search-radio').checked){
		let template = document.createElement("div")
		template.setAttribute("id","div-author")
		let newContent = document.createTextNode("Authors ")
		let templateChild = document.createElement("select")
		templateChild.setAttribute("id","author-select")
		for(var key in payload.authors){
			templateChild.innerHTML += `<option id=${payload.authors[key][0]} value="${payload.authors[key][1]}">${payload.authors[key][1]}</option>`
		}
		template.appendChild(newContent)
		template.appendChild(templateChild)
		form.insertBefore(template,sub)

		template = document.createElement("div")
		template.setAttribute("id","div-genre")
		newContent = document.createTextNode("Genres ")
		templateChild = document.createElement("select")
		templateChild.setAttribute("id","genre-select")
		for(var key in payload.genres){
			templateChild.innerHTML += `<option id=${payload.genres[key][0]} value="${payload.genres[key][1]}">${payload.genres[key][1]}</option>`
		}
		template.appendChild(newContent)
		template.appendChild(templateChild)
		form.insertBefore(template,sub)

		template = document.createElement("div")
		template.setAttribute("id","div-publisher")
		newContent = document.createTextNode("Publishers ")
		templateChild = document.createElement("select")
		templateChild.setAttribute("id","publisher-select")
		for(var key in payload.publishers){
			templateChild.innerHTML += `<option id=${payload.publishers[key][0]} value="${payload.publishers[key][1]}">${payload.publishers[key][1]}</option>`
		}
		template.appendChild(newContent)
		template.appendChild(templateChild)
		form.insertBefore(template,sub)
	}else if(dropdown.val() == "mangas"){
		let template = document.createElement("div")
		template.innerHTML = `Author <input id="author-input" type="text">`
		form.insertBefore(template,sub)
		template = document.createElement("div")
		template.innerHTML = `Publisher <input id="publisher-input" type="text">`
		form.insertBefore(template,sub)
		template = document.createElement("div")
		template.innerHTML = `Genre <input id="genre-input" type="text">`
		form.insertBefore(template,sub)
	}
})

submit.on('click', event =>{
	if(dropdown.val() == "mangas" && document.getElementById('input-radio').checked){
		let one = $("#author-select")
		let two = $("#genre-select")
		let three = $("#publisher-select")
		let score = $("#manga-input")
		let o_id = $("#author-select").find('option:selected').attr('id')
		let t_id = $("#genre-select").find('option:selected').attr('id')
		let th_id = $("#publisher-select").find('option:selected').attr('id')
		channel.push('submit:manga', {publisher: three.val(),publisher_id: th_id,
									  genre: two.val(),genre_id: t_id,
									  author: one.val(),author_id: o_id, score: score.val()})
	} else if(document.getElementById('search-radio').checked){
		switch(dropdown.val()){
			case "authors":
				let one = $("#author-name")
				let two = $("#author-surname")
				let three = $("#author-birth")
				let rating = $("#author-rating")
				channel.push('author:search',{name: one.val(),surname: two.val(), birth: three.val(), rating: rating.val()})
				break;
			case "genres":
				one = $("#genre-name")
				two = $("#genre-description")
				channel.push('genre:search',{name: one.val(),description: two.val()})
				break;
			case "mangas":
				one = $("#manga-input")
				two = $("#author-input")
				three = $("#publisher-input")
				let four = $("#genre-input")
				console.log(`kek ${one.val()} ${two.val()} ${three.val()} ${four.val()}`)
				channel.push('manga:search',{score: one.val(),author: two.val(),publisher: three.val(),genre: four.val()})
				break;
			case "publishers":
				one = $("#publisher-name")
				two = $("#publisher-city")
				three = $("#publisher-country")
				four = $("#publisher-rating")
				channel.push('publ:search',{name: one.val(),city: two.val(),country: three.val(),rating: four.val()})
				break;
		}
	}
})

channel.on('manga:found', payload =>{
	console.log(payload.anwser+"\n")
})


channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket

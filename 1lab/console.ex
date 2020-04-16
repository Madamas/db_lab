# {[{Name,City,Country}],[{Rating,Birth,Name+Surname,Team}]}
defmodule Console do
	def start do
		{:ok, pid} = Team_Player.start_link
		process("0",pid)
	end
	def process(num,pid) when num == "0" do
		num = IO.gets "Please, enter desired option:\n 1. Add entry\n 2.Update entry\n 3.Delete entry\n 4.Show best players\n 5.Show system state\n"
		num = Regex.replace(~r{\n},num,"")
		process(num,pid)
	end
	def process(num,pid) when num == "1" do
		:timer.sleep(500)
		choise = IO.gets "Team or player? "
		choise = Regex.replace(~r{\n},choise,"")
		case choise do
			"player" ->
			rating = IO.gets "Enter player's rating "
			rating = Regex.replace(~r{\n},rating,"")
			{num,_} = Integer.parse(rating)
			birth = IO.gets "Enter player's birth date "
			birth = Regex.replace(~r{\n},birth,"")
			name = IO.gets "Enter player's name and surname "
			name = Regex.replace(~r{\n},name,"")
			team = IO.gets "Enter player's team "
			team = Regex.replace(~r{\n},team,"")
			Team_Player.add_entry(pid,[num,birth,name,team])
			process("0",pid)
			"team" ->
			name = IO.gets "Enter team's name "
			name = Regex.replace(~r{\n},name,"")
			city = IO.gets "Enter team's city "
			city = Regex.replace(~r{\n},city,"")
			country = IO.gets "Enter team's country "
			country = Regex.replace(~r{\n},country,"")
			Team_Player.add_entry(pid,[name,city,country])
			process("0",pid)
			_-> IO.puts "sorry, didn't recognize it\n"
			process("0",pid)
		end
	end
	def process(num,pid) when num == "2" do
		:timer.sleep(500)
		choise = IO.gets "Team or player? "
		choise = Regex.replace(~r{\n},choise,"")
		case choise do
			"player" ->
			rating = IO.gets "Enter player's rating "
			rating = Regex.replace(~r{\n},rating,"")
			birth = IO.gets "Enter player's birth date "
			birth = Regex.replace(~r{\n},birth,"")
			name = IO.gets "Enter player's name and surname "
			name = Regex.replace(~r{\n},name,"")
			team = IO.gets "Enter player's team "
			team = Regex.replace(~r{\n},team,"")
			index = IO.gets "Enter field index "
			index = Regex.replace(~r{\n},index,"")
			field = IO.gets "Enter on what to change "
			field = Regex.replace(~r{\n},field,"")
			{num,_} = Integer.parse(index)
			Team_Player.update_entry(pid,[rating,birth,name,team],num,field)
			process("0",pid)
			"team" ->
			name = IO.gets "Enter team's name "
			name = Regex.replace(~r{\n},name,"")
			city = IO.gets "Enter team's city "
			city = Regex.replace(~r{\n},city,"")
			country = IO.gets "Enter team's country "
			country = Regex.replace(~r{\n},country,"")
			index = IO.gets "Enter field index"
			index = Regex.replace(~r{\n},index,"")
			field = IO.gets "Enter on what to change "
			field = Regex.replace(~r{\n},field,"")
			{num,_} = Integer.parse(index)
			Team_Player.update_entry(pid,[name,city,country],num,field)
			process("0",pid)
			_-> IO.puts "sorry, didn't recognize it\n"
			process("0",pid)
		end
	end
	def process(num,pid) when num == "3" do
		:timer.sleep(500)
		choise = IO.gets "Team or player? "
		choise = Regex.replace(~r{\n},choise,"")
		case choise do
			"player" ->
			rating = IO.gets "Enter player's rating "
			rating = Regex.replace(~r{\n},rating,"")
			birth = IO.gets "Enter player's birth date "
			birth = Regex.replace(~r{\n},birth,"")
			name = IO.gets "Enter player's name and surname "
			name = Regex.replace(~r{\n},name,"")
			team = IO.gets "Enter player's team"
			team = Regex.replace(~r{\n},team,"")
			Team_Player.delete_entry(pid,[rating,birth,name,team])
			process("0",pid)
			"team" ->
			name = IO.gets "Enter team's name "
			name = Regex.replace(~r{\n},name,"")
			city = IO.gets "Enter team's city "
			city = Regex.replace(~r{\n},city,"")
			country = IO.gets "Enter team's country "
			country = Regex.replace(~r{\n},country,"")
			Team_Player.delete_entry(pid,[name,city,country])
			process("0",pid)
			_-> IO.puts "sorry, didn't recognize it\n"
			process("0",pid)
		end
	end
	def process(num,pid) when num == "4" do
		Team_Player.show_best(pid)
		:timer.sleep(1500)
		process("0",pid)
	end
	def process(num,pid) when num == "5" do
		Team_Player.show_state(pid)
		:timer.sleep(1500)
		process("0",pid)
	end
end
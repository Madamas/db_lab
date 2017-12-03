# Player   -    Team 
#  number  - 	Name
#  Team Name/Num  -  City
#  Birth Date  - 	Country
#  Name and Surname - 
# Team name/num is linked to actual team and if there's any amount of players more
#		Team 					Player
# {[{Name,City,Country}],[{Rating,Birth,Name+Surname,Team}]}
defmodule Team_Player do
	use GenServer 
	#Client
	def start_link do
		teams = readFiles("teams.md")
		players = readFiles("players.md")
		GenServer.start_link(__MODULE__,{teams,players})
	end
		#players
	def delete_entry(pid,data) when length(data)==4 do
		GenServer.call(pid,{:delete,data})
	end

	def update_entry(pid,who,index,data) when length(who)==4 do
		GenServer.call(pid,{:update,who,index,data})
	end

	def add_entry(pid,data) when length(data)==4 do
		GenServer.call(pid,{:add,data})
	end
		#teams
	def delete_entry(pid,data) when length(data)==3 do
		GenServer.call(pid,{:delete,data})
	end

	def update_entry(pid,who,index,data) when length(who)==3 do
		GenServer.call(pid,{:update,who,index,data})
	end
	
	def add_entry(pid,data) when length(data)==3 do
		GenServer.call(pid,{:add,data})
	end

	def show_state(pid) do
		Process.send_after(pid,:show_state, 1000)
	end

	def show_best(pid) do
		Process.send_after(pid,:show_best, 1000)
	end

	#Server
	def init(state) do
		{:ok, state}
	end
		#players
	def handle_call({:delete,data}, _from, {t,p}) when length(data)==4 do
		[o|[tw|[th|[f]]]] = data
		{o,_} = Integer.parse(o)
		writeTo({t,p -- [{o,tw,th,f}]})
		{:reply,"deleted",{t,p -- [{o,tw,th,f}]}}
	end

	def handle_call({:update,who,index,data},_from,{t,p}) when length(who)==4 do
		[o|[tw|[th|[f]]]] = who
		{num,_} = Integer.parse(o)
		{d,_} = Integer.parse(data)
		list = Enum.map(p, fn(tuple) -> 
		{one,two,three,four} = tuple	
			if((one == num) and (two == tw) and (th == three) and (f == four)) do
				Tuple.delete_at(tuple,index)
				|> Tuple.insert_at(index, d)
			else
			{one,two,three,four}
			end
		end)
		writeTo({t,list})
		{:reply, "updated", {t,list}}
	end

	def handle_call({:add,data},_from,{t,p}) when length(data)==4 do
		[o|[tw|[th|[f]]]] = data
		{num,_} = Integer.parse(o)
		list = Enum.filter(p, fn({one,two,three,four}) -> ((one == o) and (two == tw) and (th == three) and (f == four)) end)
		if(length(list) != 0) do
			{:reply, "duplicate", {t,p}}
		else
			writeTo({t,p ++ [{num,tw,th,f}]})
			{:reply, "added", {t,p ++ [{num,tw,th,f}]}}
		end
	end
		#teams
	def handle_call({:update,who,index,data},_from,{t,p}) when length(who)==3 do
		[o|[tw|[th]]] = who
		list = Enum.map(t, fn(tuple) -> 
			{one,two,three} = tuple
			if((one == o) and (two == tw) and (th == three)) do
					Tuple.delete_at(tuple,index)
					|> Tuple.insert_at(index, data)
			else
			{one,two,three}
			end
			end)
		writeTo({list,p})
		{:reply, "updated", {list,p}}
	end

	def handle_call({:delete,data}, _from, {t,p}) when length(data)==3 do
		[o|[tw|[th]]] = data
		sort = Enum.filter(p, fn({_,_,_,team})-> o==team end)
		case length(sort) do
			0->
			writeTo({t -- [{o,tw,th}],p})
			{:reply,"deleted",{t -- [{o,tw,th}],p}}
			_->
			IO.puts "there's still players in this team"
			{:reply,"there's still players in this team",{t,p}}
		end
		
	end

	def handle_call({:add,data},_from,{t,p}) when length(data)==3 do
		[o|[tw|[th]]] = data
		list = Enum.filter(t, fn({one,two,three}) -> ((one == o) and (two == tw) and (th == three)) end)
		if(length(list) != 0) do
			{:reply, "duplicate", {t,p}}
		else
			writeTo({t ++ [List.to_tuple(data)],p})
			{:reply, "added", {t ++ [List.to_tuple(data)],p}}
		end
	end

	def handle_info(:show_state,{t,p}) do
		IO.inspect t, label: "TEAM"
		IO.inspect p, label: "PLAYERS"
		{:noreply,{t,p}}
	end

	def handle_info(:show_best,{t,p}) do
		findBest(1,{t,p})
		{:noreply,{t,p}}
	end

	defp writeTo({t,p}) do
		File.rm("teams.md")
		File.rm("players.md")
		{:ok, tpid} = File.open("teams.md",[:write])
		{:ok, ppid} = File.open("players.md",[:write])
		Enum.map t, fn entry ->
			{one,two,three} = entry
			IO.write tpid, "#{one}"<>",#{two}"<>",#{three}\n"
		end
		Enum.map p, fn entry ->
			{one,two,three,four} = entry
			IO.write ppid, "#{one}"<>",#{two}"<>",#{three}"<>",#{four}\n"
		end
	end

	defp findBest(num,{t,p}) do
		list = Enum.map t, fn x ->
			{clubname, _,_} = x
			Enum.filter(p, fn {rating,_,_,team} ->(team==clubname and rating <= num) end)
		end
		Enum.map list, fn x ->
			Enum.map x, fn player ->
				{rating,birth,name,team} = player
				IO.puts "Name: #{name}\n"<> "Birthdate: #{birth}\n" <>"Rating: #{rating}\n"<>"Team: #{team}\n"
			end
			IO.puts "\n"
		end
	end

	defp readFiles(filename) do
		{atom,pid} = File.open filename, [:utf8]
		acc = case atom do
			:error -> []
			:ok -> fileHandle pid,[]
		end
		acc
	end

	defp fileHandle(pid,acc) do
		string = IO.read pid, :line
		case string do
			:eof -> File.close pid
			acc
			_->
			string = Regex.replace(~r/\n/,string,"",global: true)
			string = Regex.split(~r{\,},string,trim: true)
			[h|t] = string
			response = Integer.parse(h)
			case response do
				:error -> 
				tup = List.to_tuple(string)
				fileHandle(pid,acc ++ [tup])
				{num,_}->
				tup = List.to_tuple([num|t])
				fileHandle(pid,acc ++ [tup])
			end
		end
	end
end
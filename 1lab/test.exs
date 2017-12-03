defmodule Test do
	def someFunc({data1,data2}) do
		IO.inspect data1
		IO.inspect data2
		IO.puts "bitch"

	end
	def someFunc(data) when length(data)==2 and is_list(data) do
		IO.inspect data
		IO.puts "fuck\n"
	end
	def someFunc(data) when length(data)==1 and is_list(data) do
		IO.inspect data
		IO.puts "fick\n"
	end

	def someFunc(data) do
		IO.inspect data
		IO.puts "nope\n"
	end

	def findBest({t,p}) do
			list = Enum.map t, fn x ->
				Enum.filter(p, fn {one,two} -> (x == two) end)
			end
			list
	end
end
# {[{Name,City,Country}],[{Rating,Birth,Name+Surname,Team}]}
list = ["Tottengham","Liverpoor","Canada"]
list1 = ["Arsenal", "London", "UK"]

list2 = [1,"11.22.12", "Hugh Haffner", "Arsenal"]
list3 = [2,"22.13.23", "John Doe", "Tottengham"]
list4 = [3,"33.14.24", "Hugh Moe", "Arsenal"]
list5 = [4,"44.15.25", "Kek Sdak", "Tottengham"]
list6 = [5,"55.15.26", "Kek Bung", "Arsenal"]

list1 = [1,2,3,4,5]
list2 = [{"kek",1},{"kepol",2},{"klkek",3},{"kesadsak",4},{"kedfdsk",5},{"kasdasdek",1},{"keasdasdk",2},{"kasdasdek",3},{"keasdasdk",4},{"kesad",5}]

Test.findBest({list1,list2})

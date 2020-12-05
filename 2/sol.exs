defmodule Passwords do
	def main(part) do
		str = File.read!("input")
		{:ok, stream} = str |> StringIO.open()
		stream
		|> IO.binstream(:line)
		|> Enum.map(fn x ->
			Task.async(fn ->
				[a,b,c,d]=Regex.run(~r/(\d+)-(\d+) (.): (.*)/, x, capture: :all_but_first)
				if part==1 do
					Enum.count(String.graphemes(d), & &1==c) in String.to_integer(a)..String.to_integer(b)&&1||0
				else
					((String.at(d,String.to_integer(a)-1)==c) != (String.at(d,String.to_integer(b)-1)==c))&&1||0
				end
			end)
		end)
		|> Enum.reduce(0, fn e, acc->Task.await(e)+acc end)
		|> IO.inspect()
	end
end

Passwords.main(1)
Passwords.main(2)

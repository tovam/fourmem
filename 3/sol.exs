defmodule Trees do
	def count(x, y) do
		str = File.read!("input")
		{:ok, stream} = str |> StringIO.open()
		stream
		|> IO.binstream(:line)
		|> Enum.reduce({0, nil, 0}, fn l, {r, len, i} ->
			len=len||String.length(l)-1
			if rem(i,y)==0 do
				{r+if(String.at(l, rem(div(i*x,y), len))=="#", do: 1, else: 0), len, i+1}
			else
				{r, len, i+1}
			end
		end)
		|> elem(0)
	end
	def counts_mult(cs), do: Enum.reduce(for {x,y}<-cs do count(x, y) end, &*/2) |> IO.inspect()

	def main1(), do: counts_mult([{3,1}])
	def main2(), do: counts_mult([{1,1},{3,1},{5,1},{7,1},{1,2}])
end

Trees.main1()
Trees.main2()

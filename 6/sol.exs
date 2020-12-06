defmodule Questions do
	def parse_questions(merge) do
		File.read!("input")
		|> String.split(~r/\n{2,}/, trim: true)
		|> Enum.map(&String.split(&1, "\n", trim: true) |> Enum.reduce(nil, fn
				e, nil -> MapSet.new(String.graphemes(e))
				e, acc -> merge.(acc, MapSet.new(String.graphemes(e)))
			end) |> MapSet.size())
		|> Enum.reduce(0, &+/2)
		|> IO.inspect()
	end
	def main1(), do: parse_questions(&MapSet.union/2)
	def main2(), do: parse_questions(&MapSet.intersection/2)
end

Questions.main1()
Questions.main2()

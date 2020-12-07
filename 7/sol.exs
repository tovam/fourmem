defmodule Bags do
	def add_content([]), do: %{}
	def add_content(["no other"]), do: %{}
	def add_content([n,type|content]), do: Map.merge(%{type => String.to_integer(n)}, add_content(content))
	def parse_rule([container|content]), do: %{container => add_content(content)}
	def add_rev_content([], _container), do: %{}
	def add_rev_content(["no other"], _container), do: %{}
	def add_rev_content([_n,type|content], container), do: Map.merge(%{type => [container]}, add_rev_content(content, container))
	def parse_rev_rule([container|content]), do: add_rev_content(content, container)
	def count_children(m, root) do
		(m[root]||%{})
		|> Enum.map(fn {type,n} -> n*count_children(m, type) end)
		|> Enum.sum()
		|> (& &1+1).()
	end
	def find_all_children(m, root) do
		List.wrap(m[root])
		|> (& &1++Enum.flat_map(&1,fn x->find_all_children(m, x)end)).()
		|> Enum.uniq()
	end
	def final_rules(parse_rev_rule) do
		File.read!("input")
		|> String.split("\n", trim: true)
		|> Enum.map(fn r->String.split(r, ~r/( bags contain |, |(?<=\d) |\.| bags?)/, trim: true)end)
		|> Enum.reduce(%{}, fn r,acc->Map.merge(acc, parse_rev_rule.(r), fn _k,v,vv -> v++vv end)end)
	end
	def main1() do
		final_rules(&parse_rev_rule/1)
		|> find_all_children("shiny gold")
		|> length()
		|> IO.inspect()
	end
	def main2() do
		final_rules(&parse_rule/1)
		|> count_children("shiny gold")
		|> (& &1-1).()
		|> IO.inspect()
	end
end

Bags.main1()
Bags.main2()

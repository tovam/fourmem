defmodule Plane do
	def x(_, r\\0)
	def x("F"<>a, r), do: x(a, 2*r)
	def x("B"<>a, r), do: x(a, 2*r+1)
	def x("L"<>a, r), do: x(a, 2*r)
	def x("R"<>a, r), do: x(a, 2*r+1)
	def x("", r), do: r

	for {name, q}<-[
		main1: quote(do: Enum.max()),
		main2: quote(do: (&List.first(Enum.to_list(Enum.min(&1)..Enum.max(&1))--&1)).())
	] do
		def unquote(name)() do
			"input"
			|> File.read!()
			|> String.split("\n", trim: true)
			|> Enum.map(&x/1)
			|> unquote(q)
			|> IO.inspect()
		end
	end
end

Plane.main1()
Plane.main2()

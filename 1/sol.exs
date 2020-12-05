defmodule M do
	defmacro defprodsums(n, opts \\ []) do
		for i<-2..n do
			prodsum(i, Keyword.put(opts, :first, true))
		end
	end
	def prodsum(n, opts \\ [])
	def prodsum(0, _opts) do
		quote do
			s=s+x
			p=p*x
			l2=[x|l2]
			case s do
				^tot -> {:halt, p}
				w -> {if(w<tot, do: :halt, else: :cont), nil}
			end
		end
	end
	def prodsum(n, opts) do
		first=opts[:first]
		start=if first do
			quote do (l=Enum.sort(l0);s=0;p=1;reve=Enum.reverse(l);l2=[]) end
		else
			quote do (s=s+x;l=l--[x];p=p*x;l2=[x|l2];reve=Enum.reverse(l)) end
		end
		body=quote do
			unquote(start)
			if s>tot do
				{:halt, nil}
			else
				{
					:cont,
					unquote(n>1 && quote(do: l) || quote(do: reve))
					|> Enum.reduce_while(nil, fn
						x, nil -> unquote(prodsum(n-1, Keyword.delete(opts, :first)))
						_, x -> {:halt, x}
					end)
				}
			end
		end
		if first do
			name=:"find#{n}"
			quote do
				def unquote(name)(l0, tot), do: unquote(body) |> elem(1)
			end
		else
			body
		end
	end
end

defmodule Sums do
	import M
	defprodsums 3
	def input(), do: Enum.map(String.split(File.read!("input")), &String.to_integer/1)
	def main1(), do: IO.inspect(find2(input(), 2020))
	def main2(), do: IO.inspect(find3(input(), 2020))
end

Sums.main1()
Sums.main2()

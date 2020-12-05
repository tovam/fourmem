defmodule Passport do
  def check(%{}=a), do: try(do: check(Enum.map(a, & &1)), rescue: (_e->false))
  def check([{"byr", a}|z]), do: (String.to_integer(a) in 1920..2002) && check(z)
  def check([{"iyr", a}|z]), do: (String.to_integer(a) in 2010..2020) && check(z)
  def check([{"eyr", a}|z]), do: (String.to_integer(a) in 2020..2030) && check(z)
  def check([{"hgt", <<a::binary-size(3)>><>"cm"}|z]), do: (String.to_integer(a) in 150..193) && check(z)
  def check([{"hgt", <<a::binary-size(2)>><>"in"}|z]), do: (String.to_integer(a) in 59..76) && check(z)
  def check([{"hcl", "#"<>a}|z]), do: (Regex.match?(~r/^[0-9a-f]{6}$/, a)) && check(z)
  def check([{"ecl", a}|z]) when a in ["amb","blu","brn","gry","grn","hzl","oth"], do: check(z)
  def check([{"pid", a}|z]), do: (Regex.match?(~r/^[0-9]{9}$/, a)) && check(z)
  def check([{"cid", _}|z]), do: check(z)
  def check([]), do: true
  def check(_), do: false

  for {name, q}<-[main1: quote(do: var!(a)), main2: quote(do: check(var!(a)))] do
    def unquote(name)() do
      File.read!("input")
      |> String.split(~r/\n{2,}/)
      |> Enum.map(& String.split(&1,~r/(?:\n| )+/, trim: true) |> Enum.into(%{}, fn x->List.to_tuple(String.split(x, ":", parts: 2))end))
      |> Enum.filter(fn
        %{"byr"=>_,"iyr"=>_,"eyr"=>_,"hgt"=>_,"hcl"=>_,"ecl"=>_,"pid"=>_}=a->unquote(q)
        _->false
      end)
      |> length()
      |> IO.inspect()
    end
  end
end

Passport.main1()
Passport.main2()

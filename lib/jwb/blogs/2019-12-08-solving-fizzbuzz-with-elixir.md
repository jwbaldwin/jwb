---
slug: solving-fizzbuzz-with-elixir
title: Solve FizzBuzz in Elixir
description: FizzBuzz with multiple solutions in Elixir. Which is best?
tags: ["elixir", "tutorial"]
---

## Why FizzBuzz?
It’s a problem everyone knows, so we can focus more on the way I solve it, than how I solve it.

## The Solutions
Elixir is a functional language. And it’s very flexible.

This means there are tons of ways to solve a problem like FizzBuzz, and sometimes that means too many.

Let’s take a look at two ways we can use Elixir’s features to solve FizzBuzz in a clean and readable way. I don’t think one is better than the other, that’s for you to decide.

Though, it’s my opinion that the one that doesn’t make you say ugh, or scratch your head, is the better one.

>“Whenever I have to think to understand what the code is doing, I ask myself if I can refactor the code to make that understanding more immediately apparent.”
— Martin Fowler

## 1. Guards
https://hexdocs.pm/elixir/guards.html

The first solution uses Elixir’s guards. A feature that augments pattern matching by allowing you to add some additional checks to your function.
i.e. ( from the docs)

```elixir
def empty_map?(map) when map_size(map) == 0, do: true
def empty_map?(map) when is_map(map), do: false
```

Here’s what is looks like when applied to FizzBuzz
```elixir
defmodule GaurdFizzBuzz do
  def solve(min, max), do: Enum.each(min..max, &(solve(&1)))
  def solve(num) when (rem(num, 15) == 0), do: IO.puts "FizzBuzz"
  def solve(num) when (rem(num, 5) == 0), do: IO.puts "Buzz"
  def solve(num) when (rem(num, 3) == 0), do: IO.puts "Fizz"
  def solve(num), do: IO.puts num
end
```


## 2. Conditionals
https://elixir-lang.org/getting-started/case-cond-and-if.html

The second solution uses Elixir’s conditionals. 
A way to match based off of some operations. Like a condensed and simple way to do `if-else's`

They look a bit like `switch` statements, but operate like an `if` clause.

i.e. ( from the docs)
```elixir
cond do
  2 + 2 == 5 -> "This is never true"
  2 * 2 == 3 -> "Nor this"
  true -> "This is always true (equivalent to else)
end
```

Here’s what is looks like when applied to FizzBuzz!
```elixir
defmodule MatchFizzBuzz do
  def solve(min, max), do: Enum.each(min..max, &(solve(&1)))
  def solve(num) do
    cond do
      rem(num, 15) == 0 -> IO.puts "FizzBuzz"
      rem(num, 5) == 0  -> IO.puts "Buzz"
      rem(num, 3) == 0  -> IO.puts "Fizz"
      true              -> IO.puts num
    end
  end
end
```

## Conclusion
Which is better? Each has its merits. And as far as which I would rather see in a production code-base. I’m not really certain. Let’s take a look at the pros and cons:

Gaurds
1. Are not as readable when used for lots of pattern matching
2. Would be more extendable and testable.

Conds
1. Are more readable.
2. Would be harder to extend if some other requirements came down.
3. You’d have to refactor it if you wanted to add additional logic to it.

It’s really up to you and your team which you’d rather work-with. Often the finally level of optimization (guard v.s. cond) is not worth it. Shipped code is the best code.

So there you have it! FizzBuzz solved in two ways, each using a different language feature of Elixir.

Thanks for reading :)
Catch me on twitter https://twitter.com/jwbaldwin_

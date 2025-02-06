---
slug: ecto-pipe-versus-keyword-syntax
title: Ecto.Query Macro-based vs. Keyword syntax
description: A gentle introduction to Ecto's query syntaxes
tags: ["elixir", "ecto", "tutorial"]
---
# Intro

In Ecto, there are two ways to write and compose queries. Neither is necessarily better than the other, but today we'll look at how to accomplish the same thing with either syntax.

Since most of the [`Ecto.Query` documentation](https://hexdocs.pm/ecto/Ecto.Query.html) examples use the `keyword` syntax, but the Phoenix generators use what is called the `macro`, or also the `pipe`, syntax, I was initially quite tripped up when I started having to write more complex queries.
(See: [Ecto.Query documentation source](https://github.com/elixir-ecto/ecto/blob/e9dead98b1fe2f20358faee48b7fe00f17a71bc2/lib/ecto/query.ex#L14)).


Hopefully, this can help serve as a translation guide, and introduction to, both syntaxes.

## Difference
The `keyword` and `pipe` syntax are functionally equivalent, that's the important bit.

In reality, the `macro-based` aka `pipe` syntax was built to take advantage of the `|>` pipe operator that's very prevalent in Elixir.

Meanwhile, the keyword syntax looks very similar to raw SQL, and can be easier to reason about when composing pieces of a complex query.

Perhaps the biggest difference between the two syntaxes is that the `pipe` version requires explicit bindings when trying to do more complex queries. If the query is fairly simple though, the bindings are optional. Here's an example of the pipe syntax with and without bindings:

```elixir
# With binding
"users"
|> where([u], u.age > 18)
|> select([u], u.name)

# Without binding, since Ecto is smart enough to figure out the binding
"users"
|> where([u], u.age > 18)
|> select([:name])

# And if I was doing something even simpler, no bindings again
"users"
|> where(age: 18)
|> select([:name])
```

## Keyword Syntax
With the keyword syntax, the one used predominantly in the Ecto documentation, your Ecto queries take on a look very similar to raw SQL:

```elixir
query = from u in "users",
          where: u.age > 18,
          select: u.name

Repo.all(query)
```

Side note: the `from` is actually a macro.

As you can see, we use a set of keywords: ```from, in, where, select```

This form of writing Ecto.Queries is the most similar to LINQ from C#, which was one of the major inspirations for Ecto and its syntax. Likewise, it tends to be the syntax that reads the best when queries become larger than your simple "Get thing where id is 1".


## Pipe |> Syntax
When leveraging the `pipe` syntax, the one that is used in the Phoenix generators, it's often a lot simpler to construct and execute simple queries in a single pass.

For example, you might see a `keyword` query like this:

```elixir
query = from p in "posts"
  where: p.id == ^id,

Repo.all(query)
```

Is simpler looking in the `pipe` syntax

```elixir
"posts"
|> where(id: ^id)
|> Repo.all()
```

For your simpler queries, this syntax is very fluent and expressive - but can be more unwieldy when you need to perform more complex queries with bindings.

## Conlusion
 
The guidelines I use when choosing one or the other (aside from being consistent with your chosen syntax) is to use the `pipe` syntax when my queries are simple (i.e. do not require explicit bindings) and I'll reach for the `keyword` syntax when I need to compose queries or use bindings.

Ultimately, seeing as both syntaxes are equivalent, it comes down to personal/team preference.

---
layout: post
title: Replicating Clojure's Conditional Threading in Elixir
date: 2024-03-29
tags: programming elixir clojure
---
One of my favorite functions in Clojure is `cond->`. `cond->` is useful when I need to conditionally build out a map or a list, a very common scenario.

```clojure

(let [case1 true
      case2 false]
(cond-> {}
  case1 (assoc :a 1)
  case2 (assoc :b 2))
;; {:a 1}
```

I recently ran into into a function in an Elixir project that needed to conditionally build out a map.
The implementation used a `case` statement with pattern matching:

```elixir
result = case {case1, case2} do
  {false, false} -> %{}
  {true, false} -> %{a: 1}
  {false, true} -> %{b: 2}
  {true, true} -> %{a: 1, b: 2}
end
```

While this approach returns the result we're looking for, whoever reads/maintains this code will need to think about every combination of conditionals.
This is good enough for two conditionals, but what if a third is needed? A fourth?
Every new conditional will increase the complexity exponentially and will make the code susceptible to accidental errors.
Instead of writing this code as a set of hardcoded rules, I wanted to represent of this as a data transformation and try to replicate the behavior of `cond->` in Elixir.

Elixir has a pipe operator (`|>`) that is the Elixir equivalent to the thread first macro in clojure (->).
This passes the result of the previous function into the first argument of the next.

To handle our conditionals, [we'll use the `then/2` macro](https://hexdocs.pm/elixir/1.12.3/Kernel.html#then/2). `then/2` takes a value and a function with that value as an argument, where we'll put our conditional logic. Combining `|>` and `then/2` will let us pipe the initial data structure through functions that can help us conditionally build our map.


```elixir
cond1 = true
cond2 = false

%{}
  |> then(fn args ->
       case cond1 do
         true -> Map.put(args, :a, 1),
	 _ -> args
       end
     end)
  |> then(fn args ->
       case cond1 do
         true -> Map.put(args, :b, 2),
	 _ -> args
       end
    end)
#=> %{a: 1}
```

In each of the functions we've passed to `then`, we're checking the conditional, then updating the map if the conditional is true.
If the conditional isn't true, we return the original map that passed into `then`.

You can refactor out the `then` as so:

```elixir
def cond_then(input, conditional, output_fn) do
  case conditional do
    true -> output_fn.(input)
    _ -> input
  end
end

%{}
  |> cond_then(cond1, &Map.put(&1, :a, 1))
  |> cond_then(cond2, &Map.put(&1, :b, 2))
```

Even though we aren't saving any lines of code with this approach, using `|>` and `then` describes the shape of the problem more accurately than pattern matching.
Our problem here is an example where we need to transform data from one shape into another.
This approach makes our logic more easily maintainable, we can add additional conditionals or change the initial value without changing existing case statements.

Data transformations are not specific to Clojure, they're a core part of functional programming philosopy.
However, I noticed that this way of thinking is not natural for developers who are new to functional programming, especially if the language has a flexible, forgiving syntax,
like Elixir.
This is just an example of how I'd apply functional thinking to Elixir, and how I'd explain this concept to developers who are new to functional thinking.

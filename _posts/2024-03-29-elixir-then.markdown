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

I recently ran into into a scenario in an Elixir project where a developer needed to conditionally build out a map to pass to another function.
The original implementation used a `case` statement with pattern matching:

```elixir
result = case {case1, case2} do
  {false, false} -> %{}
  {true, false} -> %{a: 1}
  {false, true} -> %{b: 2}
  {true, true} -> %{a: 1, b: 2}
end
```

While this approach returns the result we're looking for, whoever reads/maintains this code has to think about every combination of conditionals.
This is good enough for two conditionals, but it's possible that we'll need to handle a third.
Every new conditional will increase the complexity exponentially and will make the code susceptible to accidental errors.

Instead of writing this code as a set of hardcoded rules, I wanted to represent of this as a data transformation and try to replicate the behavior of `cond->` in Elixir.

Elixir has a pipe operator (`|>`) that is the Elixir equivalent to the thread first macro in clojure (->).
This passes the result of the previous function into the first argument of the next.

To handle our conditionals, [we'll use the `then/2` macro](https://hexdocs.pm/elixir/1.12.3/Kernel.html#then/2). `then/2` takes a value and a function with that value as an argument, where we'll put our conditional logic. Combining `|>` and `then/2` will let us pipe the initial data structure through functions that can help us conditionally build our map.


```elixir
cond1 = true
cond2 = false

result = %{}
  |> then(fn args ->
       case cond1 do
         true -> Map.put(args, :a, 1),
	 _ -> args
     end)
  |> then(fn args ->
       case cond1 do
         true -> Map.put(args, :b, 2),
	 _ -> args
    end)
#=> %{a: 1}
```

In each of the functions we've passed to `then`, we're checking the conditional, then updating the map if the conditional is true.
If the conditional isn't true, we return the original map that passed into `then`.

Even though we aren't saving any lines of code with this approach, using `|>` and `then` describes the shape of the problem more accurately than pattern matching.
We are not running specific code for different types, we are transforming a map based on two independent boolean variables.
This approach makes our logic more easily maintainable, we can add additional conditionals or change the initial value without changing any of the existing logic.

Data transformations are not specific to Clojure, they're a core part of functional programming philosopy.
However, I noticed it's difficult for developers who are new to functional programming to think this way naturally, especially if the language has a flexible, forgiving syntax,
like Elixir.
This is just an example of how I'd translate one of my favorite patterns in Clojure to my current Elixir project.

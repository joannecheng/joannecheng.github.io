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

I created a `cond_then`, a function influenced by the [`then/2` macro](https://hexdocs.pm/elixir/1.12.3/Kernel.html#then/2)
 `then/2` takes a value and a function with that value as an argument, where we'll put our conditional logic.

This lets us use function composition to build out our desired map.


```elixir
def cond_then(input, conditional, output_fn) do
  if conditional do
    # call the function on `input` if the conditional is true
    output_fn.(input) 
  else
    # return `input` unchanged if false
    input
  end
end

%{}
  |> cond_then(cond1, &Map.put(&1, :a, 1))
  |> cond_then(cond2, &Map.put(&1, :b, 2))
```

Even though we aren't saving lines of code with this approach, we're now thinking of our solution as a data transformation, rather than a pattern matching one.
We're applying functional programming concepts by using composition to help us transform our data into the shape we want.
By thinking this way, we can add additional conditionals or change the initial value without changing existing code.

Data transformations are not specific to Clojure, they're a core part of functional programming philosopy.
Recognizing correct approach to a problem and when our solution calls for data transformations, pattern matching, or any other functional paradigm will help us become more efficient programmers.

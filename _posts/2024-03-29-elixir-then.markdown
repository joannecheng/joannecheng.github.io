---
layout: post
title: Replicating Clojure's Conditional Threading in Elixir
date: 2024-03-29
tags: programming elixir clojure
---
One of my favorite things in [Clojure is `cond->`](https://clojuredocs.org/clojure.core/cond-%3E). `cond->` is useful when I need to conditionally build out a map or a list, a very common scenario.

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

While this approach returns the result we're looking for, it doesn't accurately describe the shape of the problem at hand.
Choosing the wrong approach leads to maintainability problems.
What if we need to check a third conditional? A fourth?
Every new conditional will increase the complexity exponentially and will make the code susceptible to accidental errors.

Instead of writing this code as a set of hardcoded rules, I wanted to go with a data transformation approach to solve this problem by replicating the behavior of `cond->` in Elixir.
Elixir has a pipe operator (`|>`) that is the Elixir equivalent to the thread first macro in clojure (->).
This passes the result of the previous function into the first argument of the next.

I created a `cond_then` function, influenced by the [`then/2` macro](https://hexdocs.pm/elixir/1.12.3/Kernel.html#then/2) and Clojure's `cond->`.
`then/2` takes a value and a function with that value as an argument.
`cond_then` takes a value, a conditional, and a function, and works identical to `cond->`.

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
We can compose a function using `|>` and `cond_then` to build out the map we want, and we do not need to know every combination of `cond1` and `cond2` values.
By thinking this way, we can add additional conditionals or change the initial value without changing existing code.

Data transformations are not specific to Clojure, they're a core part of functional programming philosopy.
Learning about different patterns in functional programming and recognizing when to apply those patterns will help us be more efficient programmers.

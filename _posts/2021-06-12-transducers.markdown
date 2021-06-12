---
layout: post
title: Clojure Transducers
date: 2021-06-11
tags: clojure clojurescript programming
---

We're given a list of users:

```clojure
(def users
  [{:first "John" :last "Parsons" :active? true}
   {:first "Amanda" :last "Clark" :active? true}
   {:first "Kevin" :last "Lawrence" :active? false}
   {:first "Caroline" :last "Mills" :active? true}
   {:first "Warren" :last "Smith" :active? false}])
```

and we need to display the full names of the active users and return the result in a list, like so:

```clojure
["John Parsons" "Amanda Clark" "Caroline Mills"]
```

For me, my first instinct in situations like this is to use `->>` (thread last).

```clojure
(->> users
     (filter #(:active? %))
     (map #(str (:first %) " " (:last %))))
;=> ["John Parsons" "Amanda Clark" "Caroline Mills"]
```

This works fine, but this way creates an extra lazy sequence after the first `filter` call. This can cause some performance issues if `users` is big or if we add more functions to thread last. We can solve this issue using [transducers](https://clojure.org/reference/transducers). 

```clojure
(def xform (comp (filter #(:active? %)) 
                 (map #(str (:first %) " " (:last %))))
```

Functions like `filter` and `map` create a transducer when they are called with one argument. When they are combined using `comp`, the result is also a transducer.

In the snippet above, I composed the `filter` and `map` functions and set the resulting transducer to `xform`. I can apply `xform` to the list of users using the [transduce](https://clojuredocs.org/clojure.core/transduce) function.

```clojure
(transduce xform conj [] users)
;=> ["John Parsons" "Amanda Clark" "Caroline Mills"]
```

`transduce` takes the transducer we just created (`xform`), a function to apply on the collection (`conj`), an optional initial value (`[]`), and a collection (`users`). Transducers are flexible: if we wanted to return a string instead, we can swap out the reducing function and initial value to return what we need.

```clojure
(transduce xf str "" users) 
;=> "John ParsonsAmanda ClarkCaroline Mills"
```

Since our original example returns the result in a collection, we can also apply our transducer to `users` using [into](https://clojuredocs.org/clojure.core/into).

```clojure
(into [] xform users)
;=> ["John Parsons" "Amanda Clark" "Caroline Mills"]
```



I often come across similar problems in my day job as a ClojureScript/[reagent](https://reagent-project.github.io/) developer. We're given sequable data that needs to be filtered, modified, and formatted into neat React components for the user. Transducers help performance by avoiding extra iterations through the data and extra lazy sequences.

### Additional Reading

[Transducers](https://clojure.org/reference/transducers) - From the Clojure.org reference

[Transducers are Coming](https://www.cognitect.com/blog/2014/8/6/transducers-are-coming) - Rich Hickey can explain transducers and reducers better than I can
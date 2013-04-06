# async\_enum

Inspired by Enumerable#lazy coupled with Enumerator::Lazy, and the Async.js library, I thought it would be cool to have syntax like `urls.async.map{ |url| http_get(url) }`.

#### Runs In Parallel

```
require 'benchmark'

sync = Benchmark.measure do
	5.times.each{ sleep 0.1 }
end

async = Benchmark.measure do
	5.times.async.each{ sleep 0.1 }
end

puts sync, async
# 0.000000   0.000000   0.000000 (  0.500782)
# 0.000000   0.010000   0.010000 (  0.102763)
```

#### How It Works

The implementation was based on `Enumerable#lazy` introduced with Ruby 2.0. `Enumerator::Async` follows a similar approach, where the Enumerator is passed into the constructor. 

```
enum = ('a'..'z').each

# these are equivalent

Enumerator::Async.new(enum)
enum.async
```

To get the enumerator back from the async enumerator, simply call `sync` like so:

```
enum.async.sync == enum
# => true
```

Every operation on the async enumerator affects the contained enumerator in the same way. For instance:

```
enum.with_index.to_a
# => [ 'a', 'b', 'c' ... ]

enum.async.with_index.to_a
# => [ 'a', 'b', 'c' ... ]
```

#### Installation

It'll be a gem

#### License

MIT
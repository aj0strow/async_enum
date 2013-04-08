# async\_enum

Inspired by Enumerable#lazy coupled with Enumerator::Lazy, and the Async.js library, I thought it would be cool to have syntax like `urls.async.map{ |url| http_get(url) }`.

#### Runs In Parallel

```ruby
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

```ruby
enum = ('a'..'z').each

# the following are equivalent

Enumerator::Async.new(enum)
enum.async
```

To get the enumerator back from the async enumerator, simply call `sync` like so:

```ruby
enum.async.sync == enum
# => true
```

Every operation on the async enumerator affects the contained enumerator in the same way. For instance:

```ruby
enum.with_index.to_a
# => [ ['a', 0], ['b', 1], ['c', 2] ... ]

enum.async.with_index.to_a
# => [ ['a', 0], ['b', 1], ['c', 2] ... ]
```

Async methods can be chained just like tipically enumerator methods:

```ruby
enum.async.each{ sleep(0.1) }.each{ sleep(0.1) }
```

#### How to use it

The method `Enumerable#async` was added so that every collection can be processed in parallel:

```ruby
[ 0, 1, 2 ].async.each{ |i| puts i }
(0..2).async.map(&:to_i)

# or chain to your heart's content

(0..5).reject(&:even?).reverse.async.with_index.map{ |x, index| x + index }
```

#### Limiting thread pool size

To limit the thread pool size, you can pass in an optional parameter to `async`. Suppose for performance reasons you want to process at most 4 elements concurrently:

```ruby
(0..100).async(4).each do
	# use bandwith
end
```

#### Installation

Install it (in the near future)

`$ gem install async_enum`

And require it

`require 'async_enum'`

#### License

MIT
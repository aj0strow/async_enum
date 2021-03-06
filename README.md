# async\_enum ![](https://travis-ci.org/aj0strow/async_enum.png)

Inspired by Enumerable#lazy coupled with Enumerator::Lazy, and the Async.js library, I thought it would be cool to have syntax like `urls.async.map{ |url| http_get(url) }`.

![](https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-prn1/554187_10151609082562269_1115589261_n.jpg)

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

To get the enumerator back from the async enumerator, simply call `sync` or `to_enum` like so:

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

Async methods can be chained just like tipical enumerator methods:

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

To limit the thread pool size, you can pass in an optional parameter to `async`. Suppose for performance reasons you want to use a maximum of 4 threads:

```ruby
(0..100).async(4).each do
	# use bandwith
end
```

#### Preventing race conditions

When programming concurrently, nasty bugs can come up because some operations aren't atomic. For instance, incrementing a variable `x += 1` will not necessarily work as expected. Use a lock when encountering these types of errors. 

```ruby
require 'async_enum'

count = 0
mutex = Mutex.new
('a'..'z').async.each do
  mutex.synchronize do
    count += 1
  end
end
count
# => 26
```

There used to be a lock DSL syntax, but it ruined using async_enum in scoped method calls. 

## Notes

To install it, add it to your gemfile:

```
# Gemfile

gem 'async_enum'
```

To run the demos, clone the project and run with the library included in the load path:

```
$ git clone git@github.com:aj0strow/async_enum
$ cd async_enum
$ ruby -I lib demos/sleep.rb 
```

#### Contributions

* Yoshida Tetsuya ([@yoshida-eth0](https://github.com/yoshida-eth0)) fixed the fiber error issue, and made the gem work with hashes.

Please report errors and feel free to contribute and improve things!


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/aj0strow/async_enum/trend.png)](https://bitdeli.com/free "Bitdeli Badge")


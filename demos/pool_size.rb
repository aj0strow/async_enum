require 'benchmark'
require 'async_enum'

default = Benchmark.measure do
  500.times.async.each{ true }
end

limited = Benchmark.measure do
  500.times.async(10).each{ true }
end

puts default, limited
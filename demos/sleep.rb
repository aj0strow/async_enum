require 'benchmark'
require 'async_enum'

sync = Benchmark.measure do
  5.times{ sleep 0.1 }
end

async = Benchmark.measure do
  5.times.async.each{ sleep(0.1) } 
end

puts sync, async
require 'benchmark'
require_relative File.join('..', 'lib', 'async_enum')

sync = Benchmark.measure do
	5.times.each{ sleep 0.1 }
end

async = Benchmark.measure do
  5.times.async.each{ sleep(0.1) } 
end

puts sync, async
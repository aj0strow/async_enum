require 'test_helper'

class BenchmarkTest < Test

  test 'async is actually async' do
    assert_performance_constant do |n|
      [n, 500].min.times.async.each{ sleep(0.01) }
    end
  end
  
end
require 'test_helper'

class BenchmarkTest < Test
  
  setup do
    @enum = 5.times.async
  end
  
  test 'async is actually async' do
    assert_performance_constant do
      @enum.each{ sleep(0.01) }
    end
  end
  
  
end
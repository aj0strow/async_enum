require 'test_helper'

class TestEnumerable < Test
  
  setup do
    @enum = 5.times.async
  end
  
  test 'safely helper method' do
    sum = 0
    @enum.each do |i|
      safely{ sum += i }
    end
    assert_equal sum, 5.times.reduce(:+)
  end
  
  test 'pools can speed things up' do
    default_start = Time.now
    500.times.async.each{ true }
    default_delta = Time.now - default_start
    
    rated_start = Time.now
    500.times.async(10).each{ true }
    rated_delta = Time.now - rated_start
    
    assert rated_delta < default_delta
  end
  
end
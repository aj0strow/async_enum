require 'test_helper'

class ThreadPoolTest < Test
  
  test 'pools can speed things up' do
    default_start = Time.now
    500.times.async.each{ true }
    default_delta = Time.now - default_start
    
    rated_start = Time.now
    500.times.async(10).each{ true }
    rated_delta = Time.now - rated_start
    
    assert rated_delta < default_delta
  end
  
  test 'pools with ranges' do
    vals = (0..7).async(4).map do |x|
      x + 2
    end
    assert_equal [2, 3, 4, 5, 6, 7, 8, 9], vals
  end
  
  test 'pools with hash' do
    values = { a: 1, b: 2 }.async(2).map do |key, value|
      [key, value * 2]
    end
    assert_equal [[:a, 2], [:b, 4]], values
  end
  
  test 'doesnt throw fiber error' do
    # implicitly will fail if error is raised
    5.times.async(2).each { sleep 0.00001 }
    assert true
  end
  
end

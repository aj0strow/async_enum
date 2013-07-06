require 'test_helper'

class ThreadPoolTest < Test
  
  setup do
    @enum = 5.times.async
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
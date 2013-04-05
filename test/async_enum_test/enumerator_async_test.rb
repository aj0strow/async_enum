require 'test_helper'

class TestEnumeratorAsync < Test
  
  setup do
    @enum = Enumerator::Async.new(1..5)
    @semaphore = Mutex.new
  end
  
  test 'enumerator each breaks without block' do
    assert_raises(ArgumentError) { @enum.each }
  end
  
  test 'enumerator async each iterates over each' do
    sum = 0
    @enum.each do |i|
      @semaphore.synchronize{ sum += i }
    end
    assert_equal (1..5).reduce(:+), sum
  end
  
end
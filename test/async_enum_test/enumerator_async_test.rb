require 'test_helper'

class TestEnumeratorAsync < Test
  
  setup do
    @enum = Enumerator::Async.new( (1..5).each )
    @semaphore = Mutex.new
  end
  
  test 'enumerator to_a returns the values of the enum' do
    assert_equal [1, 2, 3, 4, 5], @enum.to_a
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
  
  test 'async each iterates with splatting' do
    ranges = [ (1..3).to_a ] * 3
    enum = Enumerator::Async.new( ranges.each )
    sums = Hash.new(0)
    enum.each do |a, b, c|
      @semaphore.synchronize do 
        sums[a] += a
        sums[b] += b
        sums[c] += c
      end
    end
    assert_equal sums[1], 3
    assert_equal sums[2], 6
    assert_equal sums[3], 9
  end
  
  test 'enumerator map breaks without block' do
    assert_raises(ArgumentError) { @enum.map }
  end
  
  test 'enumerator map returns new array' do
    squares = @enum.map{ |i| i * i }
    assert_equal [1, 4, 9, 16, 25], squares
  end
  
  test 'async with_index without block' do
    pairs = @enum.with_index.to_a[0, 3]
    assert_equal [[1, 0], [2, 1], [3, 2]], pairs
  end
  
  test 'enumerator with index' do
    s = ''
    @enum.with_index do |x, i|
      @semaphore.synchronize{ s += "#{ x - i }" }
    end 
    assert_equal '11111', s
  end
  
end
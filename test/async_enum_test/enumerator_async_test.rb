require 'test_helper'

class TestEnumeratorAsync < Test
  
  setup do
    @enum = Enumerator::Async.new( (1..5).each )
    @semaphore = Mutex.new
  end
  
  test 'async to_a' do
    assert_equal [1, 2, 3, 4, 5], @enum.to_a
  end
  
  test 'async sync' do
    refute @enum.sync.is_a?(Enumerator::Async)
  end
  
  test 'async each no block' do
    assert_raises(ArgumentError) { @enum.each }
  end
  
  test 'async each' do
    sum = 0
    @enum.each do |i|
      @semaphore.synchronize{ sum += i }
    end
    assert_equal (1..5).reduce(:+), sum
  end
  
  test 'async each with splatting' do
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
  
  test 'async with_index no block' do
    pairs = @enum.with_index.to_a[0, 3]
    assert_equal [[1, 0], [2, 1], [3, 2]], pairs
  end
  
  test 'async with_index' do
    s = ''
    @enum.with_index do |x, i|
      @semaphore.synchronize{ s += "#{ x - i }" }
    end 
    assert_equal '11111', s
  end
  
  test 'async with_object no block' do
    h = {}
    pair = @enum.with_object(h).to_a.first
    assert_equal [ 1, h ], pair
  end
  
  test 'async with_object' do
    to_i = @enum.with_object({}) do |elem, h|
      h[ elem.to_s ] = elem
    end
    assert_equal to_i['3'], 3
  end
  
  test 'async map no block' do
    assert_raises(ArgumentError) { @enum.map }
  end
  
  test 'async map' do
    squares = @enum.map{ |i| i * i }
    assert_equal [1, 4, 9, 16, 25], squares
    
    strs = @enum.map(&:to_s)
    assert_equal '1 2 3 4 5', strs.join(' ')
  end
  
  
  
  
  
  
  
end
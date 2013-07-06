require 'test_helper'

class EnumeratorAsyncTest < Test
  
  setup do
    @enum = Enumerator::Async.new( (1..5).each )
  end
  
  test 'to_a' do
    assert_equal [1, 2, 3, 4, 5], @enum.to_a
  end

  test 'sync returns enumerator' do
    refute @enum.sync.is_a?(Enumerator::Async)
  end
  
  test 'to_enum alias of sync' do
    assert_equal @enum.sync, @enum.to_enum
  end
  
  test 'size' do
    if Enumerator.instance_methods(false).include?(:size)
      assert_equal 5, @enum.size
    else
      assert_raises(NoMethodError) { @enum.size }
    end
  end
  
  test 'each with no block' do
    assert_raises(ArgumentError) { @enum.each }
  end
  
  test 'each' do
    nums = []
    @enum.each do |i|
      nums << i
    end
    assert_equal @enum.to_a, nums.sort
  end
  
  test 'each with splatting' do
    ranges = [ ('a'..'c').to_a ] * 3
    enum = Enumerator::Async.new( ranges.each )
    strs = []
    enum.each do |a, b, c|
      strs << (a + b + c)
    end
    assert_equal %w(abc abc abc), strs
  end
  
  test 'with_index no block' do
    pairs = @enum.with_index.to_a[0, 3]
    assert_equal [[1, 0], [2, 1], [3, 2]], pairs
  end
  
  test 'with_index' do
    nums = []
    @enum.with_index do |x, i|
      nums << (x - i)
    end 
    assert_equal [1, 1, 1, 1, 1], nums
  end
  
  test 'with_object no block' do
    h = {}
    pair = @enum.with_object(h).to_a.first
    assert_equal [ 1, h ], pair
  end
  
  test 'with_object' do
    to_i = @enum.with_object({}) do |x, hash|
      hash[ x.to_s ] = x
    end
    assert_equal to_i['3'], 3
  end
  
  test 'map no block' do
    assert_raises(ArgumentError) { @enum.map }
  end
  
  test 'map' do
    squares = @enum.map{ |i| i * i }
    assert_equal [1, 4, 9, 16, 25], squares
  end
  
  test 'map keeps order' do
    strs = @enum.map{ |i| sleep rand; i.to_s }
    assert_equal '1 2 3 4 5', strs.join(' ')
  end
  
  test 'lock in block' do
    count = 0
    1000.times.async(5).each do
      lock :count do
        count += 1
      end
    end
    assert_equal 1000, count
  end

end
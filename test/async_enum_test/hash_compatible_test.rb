require 'test_helper'

class HashCompatibleTest < Test
  
  setup do
    @hash = { a: 1, b: 2 }
  end
  
  test 'hash compatible unlimited' do
    values = @hash.async.map do |key, value|
      [key, value * 2]
    end
    assert_equal [[:a, 2], [:b, 4]], values
  end
  
  test 'hash compatible' do
    values = @hash.async(2).map do |key, value|
      [key, value * 2]
    end
    assert_equal [[:a, 2], [:b, 4]], values
  end
  
end

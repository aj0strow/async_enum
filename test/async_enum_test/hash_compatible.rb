require 'test_helper'

class HashCompatibleTest < Test
  
  test 'hash compatible' do
    vals1 = {a: 1, b:2}.async.map do |x|
      [x[0], x[1] * 2]
    end
    vals2 = {a: 1, b:2}.async(2).map do |x|
      [x[0], x[1] * 2]
    end
    assert_equal [[:a, 2], [:b, 4]], vals1
    assert_equal [[:a, 2], [:b, 4]], vals2
  end
  
end

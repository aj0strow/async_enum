require 'test_helper'

class TestEnumeratorAsync < Test
  
  test 'enumerator async exists' do
    assert_equal 'constant', defined?(Enumerator::Async)
  end
  
end
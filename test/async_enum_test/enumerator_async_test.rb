require 'test_helper'

class TestEnumeratorAsync < Test
  
  test 'enumerator async exists' do
    assert_equal 'constant', defined?(Enumerator::Async)
  end
  
  test 'enumerator async descends from enumerator' do
    assert_includes Enumerator::Async.ancestors, Enumerator
  end
  
end
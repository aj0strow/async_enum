require 'test_helper'

class TestDefinitions < Test
  
  test 'enumerator async exists' do
    assert_equal 'constant', defined?(Enumerator::Async)
  end
  
  test 'enumerator async descends from enumerator' do
    assert_includes Enumerator::Async.ancestors, Enumerator
  end
  
  test 'enumerator async responds to each' do
    assert_includes Enumerator::Async.instance_methods(false), :each
  end
  
  test 'enumerator holds onto enum' do
    enum = Enumerator::Async.new(1..5)
    assert_equal 1..5, enum.instance_variable_get('@enum')
  end
  
end
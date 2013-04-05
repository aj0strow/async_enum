require 'test_helper'

class DefinitionsTest < Test
  
  setup do
    @methods = Enumerator::Async.instance_methods(false)
  end
  
  test 'enumerator async exists' do
    assert_equal 'constant', defined?(Enumerator::Async)
  end
  
  test 'enumerator async descends from enumerator' do
    assert_includes Enumerator::Async.ancestors, Enumerator
  end
  
  test 'enumerator holds onto enum' do
    enum = Enumerator::Async.new(1..5)
    assert_equal (1..5).to_a, enum.instance_variable_get('@enum').to_a
  end
    
  %w(to_a sync each map with_index).each do |method|
    test "enumerator async responds to #{method}" do
      assert_includes @methods, method.to_sym
    end
  end
  
  
end
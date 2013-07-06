require 'test_helper'

class DefinitionsTest < Test
  
  setup do
    @methods = Enumerator::Async.instance_methods(false)
  end
  
  test 'enumerator async exists' do
    assert_equal 'constant', defined?(Enumerator::Async)
  end
  
  test 'enumerator async inherits from enumerator' do
    assert_includes Enumerator::Async.ancestors, Enumerator
  end
  
  test 'enumerator holds onto enum' do
    enum = Enumerator::Async.new(1..5)
    assert_equal (1..5).to_a, enum.instance_variable_get('@enum').to_a
  end
  
  test 'enumerator holds onto pool_size' do
    enum = Enumerator::Async.new(1..5, 5)
    assert_equal 5, enum.instance_variable_get('@pool_size')
  end
    
  %w(to_a to_enum sync each map with_index with_object).each do |method|
    test "enumerator async responds to #{method}" do
      assert_includes @methods, method.to_sym
    end
  end
  
  test 'enumerable#async exists' do
    assert_includes Enumerable.instance_methods(false), :async
    assert 5.times.respond_to?(:async)
    assert (1..5).respond_to?(:async)
    assert [].respond_to?(:async)
  end
  
  
end
require 'minitest/autorun'
require 'minitest/benchmark'
require 'async_enum'



Test = MiniTest::Unit::TestCase



def setup(&block)
  define_method('setup', &block)
end

def test(test_name, &block)
  define_method("test_#{ test_name.gsub(/\s+/, '_') }", &block)
end

def cleanup(&block)
  define_method('cleanup', &block)
end

def teardown(&block)
  define_method('teardown', &block)
end



def assert_singleton_method(object, sym)
  assert object.respond_to?(sym), "Expected #{object} singleton to respond to #{sym}"
end

def assert_instance_method(object, sym)
   assert object.method_defined?(sym), "Expected #{object} instance to respond to #{sym}"
end

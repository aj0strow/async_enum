require_relative './async_enum/enumerator_async'

module Enumerable
  def async(pool_size = nil)
    enum = self.is_a?(Enumerator) ? self : self.each
    Enumerator::Async.new(enum, pool_size)
  end
end

module Kernel
  def lock(key = :__default__, &block)
    Enumerator::Async.semaphores[key].synchronize(&block)
  end
end
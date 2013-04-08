require_relative './async_enum/enumerator_async'

module Enumerable
  def async(pool_size = nil)
    enum = self.is_a?(Enumerator) ? self : self.each
    Enumerator::Async.new(enum, pool_size)
  end
end

module Kernel
  def safely(&block)
    Enumerator::Async.semaphore.synchronize(&block)
  end
end
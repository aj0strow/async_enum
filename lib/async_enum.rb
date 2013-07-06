require 'enumerator/async'

module Enumerable
  def async(pool_size = nil)
    enum = self.is_a?(Enumerator) ? self : self.each
    Enumerator::Async.new(enum, pool_size)
  end
end
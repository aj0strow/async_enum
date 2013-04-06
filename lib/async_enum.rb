require_relative './async_enum/enumerator_async'

module Enumerable
  
  def async
    enum = case self
    when Enumerator
      self
    else
      self.each
    end
    Enumerator::Async.new(enum)
  end
  
end

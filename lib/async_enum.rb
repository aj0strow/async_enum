require_relative './async_enum/enumerator_async'

class Enumerator
  
  def async
    Enumerator::Async.new(self)
  end
  
end
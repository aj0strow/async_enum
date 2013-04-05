class Enumerator
  
  class Async < Enumerator
    
    MAX_THREAD_COUNT = 10
    
    def initialize(enum)
      @enum = enum
    end
    
    
    
    def each
      raise_error('each') unless block_given?
      threads = @enum.map do |item|
        Thread.new{ yield item }
      end
      threads.each(&:join)
      @enum
    end
    
    private
    
    def raise_error(method)
      raise ArgumentError, "tried to call async #{method} without a block"
    end
    
  end
  
end
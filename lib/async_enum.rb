class Enumerator
  
  class Async < Enumerator
    
    MAX_THREAD_COUNT = 10
    
    def initialize(enum)
      @enum = enum
    end
    
    def to_a
      @enum.to_a
    end
    
    def sync
      @enum
    end
        
    def each
      raise_error('each') unless block_given?
      
      threads = @enum.map do |*args|
        Thread.new{ yield(*args) }
      end
      threads.each(&:join)
      self
    end
    
    def map
      raise_error('map') unless block_given?
      
      outs = []
      threads = @enum.with_index.map do |item, index|
        Thread.new{ outs[index] = yield(item) }
      end
      threads.each(&:join)
      outs
    end
    
    def with_index(&block)
      @enum = @enum.with_index      
      if block_given?
        each(&block)
      else
        self
      end
    end
    
    private
    
    def raise_error(method)
      raise ArgumentError, "tried to call async #{method} without a block"
    end
    
  end
  
end
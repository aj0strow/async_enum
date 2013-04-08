class Enumerator
  class Async < Enumerator
    
    @semaphore = Mutex.new
    
    class << self
      attr_reader :semaphore
    end
    
    def initialize(enum, pool_size = nil)
      @enum = enum
      @pool_size = pool_size
    end
    
    def to_a
      @enum.to_a
    end
    
    def sync
      @enum
    end
        
    def each(&block)
      raise_error('each') unless block_given?
      
      if @pool_size
        rated_each(&block)
      else
        default_each(&block)
      end
      self
    end
    
    def with_index(&block)
      @enum = @enum.with_index
      if block_given?
        each(&block)
      else
        self
      end
    end
    
    def map
      raise_error('map') unless block_given?
      
      outs = []
      enum = @enum
      with_index do |item, index|
        outs[index] = yield(item)
      end
      @enum = enum
      outs
    end
    
    def with_object(obj)
      @enum = @enum.with_object(obj)
      if block_given?
        each{ |elem, o| yield(elem, o) }
        obj
      else
        self
      end
    end

    private
    
    def default_each
      threads = @enum.map do |*args|
        Thread.new{ yield(*args) }
      end
      threads.each(&:join)
    end
    
    def rated_each
      threads = @pool_size.times.map do
        Thread.new do
          loop{ yield(* @enum.next) }
        end
      end
      threads.each(&:join)
      @enum.rewind
    end
    
    def raise_error(method)
      raise ArgumentError, "tried to call async #{method} without a block"
    end
    
  end
end
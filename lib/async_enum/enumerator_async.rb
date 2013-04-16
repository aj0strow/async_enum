class Enumerator
  class Async < Enumerator
    
    @semaphores = Hash.new do |locks, key| 
      locks[key] = Mutex.new 
    end
    
    class << self
      attr_reader :semaphores
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
        
    def each(&work)
      raise_error('each') unless block_given?
      
      if @pool_size
        threads = @pool_size.times.map do
          Thread.new do
            catch StopIteration do
              loop{ yield *@enum.next }
            end
          end
        end
        threads.each(&:join)
        @enum.rewind
      else
        unlimited_threads(&work).each(&:join)
      end
      self
    end
    
    def with_index(start = 0, &work)
      @enum = @enum.with_index(start)
      if block_given?
        each(&work)
      else
        self
      end
    end
    
    def with_object(obj, &work)
      @enum = @enum.with_object(obj)
      if block_given?
        each(&work)
        obj
      else
        self
      end
    end
    
    def map(&work)
      raise_error('map') unless block_given?
      
      if @pool_size
        outs = []
        with_index do |item, index|
          outs[index] = yield item
        end
        outs
      else
        unlimited_threads(&work).map(&:value)
      end
    end

    private
    
    def unlimited_threads
      @enum.map do |*args|
        Thread.new{ yield *args }
      end
    end

    def raise_error(method)
      raise ArgumentError, "tried to call async #{method} without a block"
    end
    
  end
end
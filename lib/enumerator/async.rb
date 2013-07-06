class Enumerator
  class Async < Enumerator
    
    class Lockset
      def initialize
        @semaphores = Hash.new do |locks, key| 
          locks[key] = Mutex.new 
        end
      end
      
      def lock(key = :__default__, &thread_unsafe_block)
        @semaphores[key].synchronize(&thread_unsafe_block)
      end
      
      alias_method :evaluate, :instance_exec
    end
    
    def initialize(enum, pool_size = nil)
      @enum = enum
      @pool_size = pool_size
      @lockset = Lockset.new
    end
    
    def to_a
      @enum.to_a
    end
    
    def sync
      @enum
    end
    
    alias_method :to_enum, :sync
    
    def size
      @enum.size
    end
        
    def each(&work)
      raise_error('each') unless block_given?
      
      if @pool_size
        threads = @pool_size.times.map do
          Thread.new do
            loop do
              @enum.any? ? evaluate(*@enum.next, &work) : break
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
        each(&work); obj
      else
        self
      end
    end
    
    def map(&work)
      raise_error('map') unless block_given?
      
      if @pool_size
        outs = []
        with_index do |item, index|
          outs[index] = evaluate(item, &work)
        end
        outs
      else
        unlimited_threads(&work).map(&:value)
      end
    end

    private
    
    def evaluate(*args, &work)
      @lockset.instance_exec(*args, &work)
    end
    
    def unlimited_threads(&work)
      @enum.map do |*args|
        Thread.new{ evaluate(*args, &work) }
      end
    end

    def raise_error(method)
      raise ArgumentError, "tried to call async #{method} without a block"
    end
    
  end
end
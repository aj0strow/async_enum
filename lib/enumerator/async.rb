require 'thread'

class Enumerator
  class Async < Enumerator
    
    EOQ = Object.new
    private_constant :EOQ
    
    def initialize(enum, pool_size = nil)
      pool_size = (pool_size || enum.count).to_i
      unless pool_size >= 1
        message = "Thread pool size is invalid! Expected a positive integer but got: #{pool_size}"
        raise ArgumentError, message
      end

      @enum, @pool_size = enum, pool_size
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
        
    def each
      raise_error(:each) unless block_given?
      
      queue = SizedQueue.new @pool_size
              
      threads = @pool_size.times.map do
        Thread.new do
          loop do
            item = queue.pop
            item != EOQ ? yield(item) : break
          end
        end
      end
      
      begin
        loop { queue.push @enum.next }
      rescue StopIteration
      ensure
        @pool_size.times { queue.push EOQ }
      end

      threads.each(&:join)
      @enum.rewind
      self
    end
    
    def with_index(start = 0, &work)
      @enum = @enum.with_index(start)
      block_given? ? each(&work) : self
    end
    
    def with_object(object, &work)
      @enum = @enum.with_object(object)
      block_given? ? (each(&work) and object) : self
    end
    
    def map
      raise_error(:map) unless block_given?
      
      [].tap do |outs|
        with_index do |item, index|
          outs[index] = yield(item)
        end
      end
    end

    private

    def raise_error(method)
      raise ArgumentError, "Tried to call async #{method} without a block"
    end
    
  end
end

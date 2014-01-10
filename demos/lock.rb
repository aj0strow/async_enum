require 'async_enum'

count = 0
mutex = Mutex.new
('a'..'z').async.each do
  mutex.synchronize do
    count += 1
  end
end
puts count
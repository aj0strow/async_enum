require 'async_enum'

count = 0
('a'..'z').async.each do
  lock :count do
    count += 1
  end
end
puts count
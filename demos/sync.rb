require 'async_enum'

enum = 5.times
puts enum.async.sync == enum
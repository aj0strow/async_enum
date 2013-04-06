require_relative File.join('..', 'lib', 'async_enum')

enum = 5.times
puts enum.async.sync == enum
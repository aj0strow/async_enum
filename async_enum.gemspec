Gem::Specification.new do |s|
  s.name        = 'async_enum'
  s.version     = '0.0.2'
  s.date        = '2013-06-06'
  s.summary     = "Async Enumerable and Enumerator"
  s.description = "iterate over enumerable objects concurrently"
  s.email       = "alexander.ostrow@gmail.com"
  s.authors     = [ "aj0strow" ]
  s.homepage    = 'http://github.com/aj0strow/async_enum'
 
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- test`.split("\n")
end
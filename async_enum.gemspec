# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'async_enum'
  s.version     = '0.0.6'
  s.authors     = %w(aj0strow)
  s.email       = 'alexander.ostrow@gmail.com'
  s.description = 'iterate over enumerable objects concurrently'
  s.summary     = 'Async Enumerable and Enumerator'
  s.homepage    = 'http://github.com/aj0strow/async_enum'
  s.license     = 'MIT'
 
  s.files = `git ls-files`.split($/)
  s.test_files  = s.files.grep(/test/)
  s.require_paths = %w(lib)
  
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
end
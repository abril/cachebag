# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

version_file = File.expand_path "../GEM_VERSION", __FILE__
File.delete version_file if File.exists? version_file

require 'step-up'
require 'cachebag'

Gem::Specification.new do |s|
  s.name          = "cachebag"
  s.version       = CacheBag::VERSION
  s.platform      = Gem::Platform::RUBY
  s.summary       = "Local HTTP cache in your REST consumers"
  s.require_paths = ['lib']
  excepts = %w[
    .gitignore
    cachebag.gemspec
    Gemfile
    Gemfile.lock
    Rakefile
  ]
  tests = `git ls-files -- {script,test}/*`.split("\n")
  s.files = `git ls-files`.split("\n") - excepts - tests + %w[GEM_VERSION]

  s.author        = "Luis Cipriani"
  s.email         = "lfcipriani@gmail.com"
  s.homepage      = "https://github.com/abril/cachebag"

  # s.add_dependency('dependency', '>= 1.0.0')

  # s.add_development_dependency('cover_me')
  # s.add_development_dependency('ruby-debug19')
  s.add_development_dependency('step-up')
end

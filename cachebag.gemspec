# encoding: UTF-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'cachebag/version'

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
  s.files = `git ls-files`.split("\n") - excepts - tests

  s.authors       = ["Luis Cipriani", "Marcelo Manzan", "Lucas Fais"]
  s.email         = ["lfcipriani@gmail.com", "manzan@gmail.com", "lucasfais@gmail.com"]
  s.homepage      = "https://github.com/abril/cachebag"

  s.add_development_dependency('step-up')
  s.add_development_dependency('rake')
  s.add_development_dependency("minitest", "~> 2.8.0") if RUBY_VERSION.start_with?("1.8")
  s.add_development_dependency('mocha')
end

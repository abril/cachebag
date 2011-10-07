Gem::Specification.new do |s|
  s.name          = "cachebag"
  s.version       = "0.0.1"
  s.platform      = Gem::Platform::RUBY
  s.summary       = "Local HTTP cache in your REST consumers"
  s.require_paths = ['lib']
  s.files         = Dir["{lib/**/*.rb,README.md,test/**/*.rb,Rakefile,*.gemspec,script/*}"]

  s.author        = "Luis Cipriani"
  s.email         = "lfcipriani@gmail.com"
  s.homepage      = "https://github.com/abril/cachebag"

  # s.add_dependency('dependency', '>= 1.0.0')

  # s.add_development_dependency('cover_me')
  # s.add_development_dependency('ruby-debug19')
end

$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"
require "bundler/setup"
# require other dependencies here...

# Gem requirements
require "cachebag/store"
module CacheBag
  autoload :VERSION, 'cachebag/version'
end

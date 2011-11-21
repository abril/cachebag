# encoding: UTF-8
$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

# Dependencies
require "rubygems"
require "bundler/setup"
require "time"

# Gem requirements
require "cachebag/base"
require "cachebag/store"
require "cachebag/http_entry"
require "cachebag/cache_control"
module CacheBag
  autoload :VERSION, 'cachebag/version'
end

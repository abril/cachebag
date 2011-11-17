require 'rubygems'
require 'minitest/spec'
require 'minitest/autorun'
require "digest/md5"

def md5(string)
  Digest::MD5.hexdigest(string)
end

# Load do ambiente da gem
require File.expand_path(File.dirname(__FILE__) + '/../lib/cachebag')

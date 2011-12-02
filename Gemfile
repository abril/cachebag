# encoding: UTF-8
source :rubygems

# Main dependencies
gem "rake"

# Other dependencies
group :test do
  gem "minitest", "~> 2.8.0", :group => [:test] if RUBY_VERSION.start_with?("1.8")
  gem "mocha"
end

gem "step-up", :group => [:source], :git => "git://github.com/kawamanza/step-up.git"

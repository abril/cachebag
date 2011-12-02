# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

describe CacheBag::Http do
  
  it "should have basic http properties" do
    @entry = CacheBag::Http.new("http://www.example.com", {"Content-Type" => "text/html"}, "<p>awesome example</p>")
    
    @entry.url.must_equal "http://www.example.com"
    @entry.headers.content_type.must_equal "text/html"
    @entry.body.must_equal "<p>awesome example</p>"
  end
  
  it "should accept the instantiation with CacheBag::Headers objects" do
    headers = CacheBag::Headers.new({ 
                "Content-Type" => "text/html", 
                "Pragma"       => "no-cache" 
              })
    
    @entry = CacheBag::Http.new("http://www.example.com", headers, "<p>awesome example</p>")
    
    @entry.url.must_equal "http://www.example.com"
    @entry.headers.content_type.must_equal "text/html"
    @entry.body.must_equal "<p>awesome example</p>"
  end
  
end

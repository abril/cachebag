# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

describe CacheBag::HttpEntry do
  
  it "should have basic http properties" do
    @entry = CacheBag::HttpEntry.new("http://www.example.com", {"Content-Type" => "text/html"}, "<p>awesome example</p>")
    
    @entry.url.must_equal "http://www.example.com"
    @entry.headers.content_type.must_equal "text/html"
    @entry.body.must_equal "<p>awesome example</p>"
  end
  
  it "should accept the instantiation with CacheBag::Headers objects" do
    headers = CacheBag::Headers.new({ 
                "Content-Type" => "text/html", 
                "Pragma"       => "no-cache" 
              })
    
    @entry = CacheBag::HttpEntry.new("http://www.example.com", headers, "<p>awesome example</p>")
    
    @entry.url.must_equal "http://www.example.com"
    @entry.headers.content_type.must_equal "text/html"
    @entry.body.must_equal "<p>awesome example</p>"
  end
  
  # Expiration Calculations: http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.2.4
  describe "freshness lifetime" do
    
    it "should return the value in seconds" do
      now_ts = Time.now
      headers = { 
                  "Date"          => now_ts.httpdate,
                  "Cache-Control" => "max-age=600",
                  "Expires"       => (now_ts + 500).httpdate
                }
      @entry = CacheBag::HttpEntry.new("http://www.example.com", headers, "<p>awesome example</p>")

      @entry.freshness_lifetime.must_equal(600)
    end
    
    it "should use expires when you don't have max-age directive" do
      now_ts = Time.now
      headers = { 
                  "Date"          => now_ts.httpdate,
                  "Expires"       => (now_ts + 600).httpdate
                }
      @entry = CacheBag::HttpEntry.new("http://www.example.com", headers, "<p>awesome example</p>")

      @entry.freshness_lifetime.must_equal(600)
    end
    
    it "should use an heuristic if none of the expiration headers are set" do
      now_ts = Time.now
      headers = { 
                  "Date" => now_ts.httpdate
                }
      @entry = CacheBag::HttpEntry.new("http://www.example.com", headers, "<p>awesome example</p>")

      @entry.freshness_lifetime.must_equal(0)
    end
    
  end
  
end

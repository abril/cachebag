# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe CacheBag::Response do
  
  it "should have times of request and response for age calculations" do
    req_time, resp_time = request_delay(5)
    @entry = CacheBag::Response.new("http://www.example.com", {"Content-Type" => "text/html"}, "<p>awesome example</p>", req_time, resp_time)
    
    @entry.url.must_equal "http://www.example.com"
    @entry.headers.content_type.must_equal "text/html"
    @entry.body.must_equal "<p>awesome example</p>"
  end
  
  it "should accept the instantiation with CacheBag::Headers objects" do
    req_time, resp_time = request_delay(5)
    headers = CacheBag::Headers.new({ 
                "Content-Type" => "text/html", 
                "Pragma"       => "no-cache" 
              })
    
    @entry = CacheBag::Response.new("http://www.example.com", headers, "<p>awesome example</p>", req_time, resp_time)
    
    @entry.url.must_equal "http://www.example.com"
    @entry.headers.content_type.must_equal "text/html"
    @entry.body.must_equal "<p>awesome example</p>"
  end
  
  # Age Calculations: http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.2.3
  describe "age calculations" do
    
    it "should return the value in seconds" do
      date      = Time.parse(Time.now.httpdate) # to avoid tiny differences
      req_time  = date + 10
      resp_time = req_time + 5
      # date-----reqtime-------resptime--------------------------------now
      # 0        0+10         10+5                                     15+100
      Time.stubs(:now).returns(resp_time + 100)
      headers = { 
                  "Date" => date.httpdate,
                }
      @entry = CacheBag::Response.new("http://www.example.com", headers, "<p>awesome example</p>", req_time, resp_time)

      @entry.age.must_equal(120)
    end
    
  end
  
  # Expiration Calculations: http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.2.4
  describe "freshness lifetime" do
    
    it "should return the value in seconds" do
      req_time, resp_time = request_delay(5)
      now_ts = Time.now
      headers = { 
                  "Date"          => now_ts.httpdate,
                  "Cache-Control" => "max-age=600",
                  "Expires"       => (now_ts + 500).httpdate
                }
      @entry = CacheBag::Response.new("http://www.example.com", headers, "<p>awesome example</p>", req_time, resp_time)

      @entry.freshness_lifetime.must_equal(600)
    end
    
    it "should use expires when you don't have max-age directive" do
      req_time, resp_time = request_delay(5)
      now_ts = Time.now
      headers = { 
                  "Date"          => now_ts.httpdate,
                  "Expires"       => (now_ts + 600).httpdate
                }
      @entry = CacheBag::Response.new("http://www.example.com", headers, "<p>awesome example</p>", req_time, resp_time)

      @entry.freshness_lifetime.must_equal(600)
    end
    
    it "should use an heuristic if none of the expiration headers are set" do
      req_time, resp_time = request_delay(5)
      now_ts = Time.now
      headers = { 
                  "Date" => now_ts.httpdate
                }
      @entry = CacheBag::Response.new("http://www.example.com", headers, "<p>awesome example</p>", req_time, resp_time)

      @entry.freshness_lifetime.must_equal(0)
    end
    
  end

  def request_delay(seconds)
    now = Time.now.to_i
    [now, now + 5]
  end
  
end

# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

describe CacheBag::Base do
  before do
    @cache = CacheBag::Base.new
  end
  
  it "should instantiate with memory store by default" do
    @cache.store.must_be_kind_of CacheBag::MemoryStore
  end
  
  it "should be a proxy for any request" do
    block_called = false
    
    response = @cache.request(:get, "http://www.example.com") do |method, url, headers, body|
      block_called = true
      # response = sample_http_lib.request(method, url, headers, body)
      [200, {"Content-Type" => "text/html"}, "<p>awesome example</p>"] # expected response format
    end
    
    response[0].must_equal 200
    response[1]["Content-Type"].must_equal "text/html"
    response[2].must_equal "<p>awesome example</p>"
    block_called.must_equal true
  end
  
  # it "should handle responses with max-age greater than 0" do
  #   now = Time.now.httpdate
  #   
  #   response = @cache.request(:get, "http://www.example.com") do
  #     headers = {
  #                 "Cache-Control" => "max-age=600", 
  #                 "Date"          => now,
  #                 "Last-Modified" => now, 
  #                 "ETag"          => md5("<p>awesome example</p>").inspect 
  #               }
  #     
  #     [200, headers, "<p>awesome example</p>"]
  #   end
  #   
  #   response[0].must_equal 200
  #   response[2].must_equal "<p>awesome example</p>"
  #   
  #   block_called = false
  #   response = @cache.request(:get, "http://www.example.com") do
  #     block_called = true
  #     [200, {}, "<p>awesome example</p>"]
  #   end
  #   
  #   block_called.must_equal false
  #   response[0].must_equal 200
  #   response[2].must_equal "<p>awesome example</p>"
  #   Time.parse(response[1]["Date"]).must_be(:>, Time.parse(response[1]["Last-Modified"]))
  #   Time.parse(response[1]["Date"]).must_be(:<, Time.parse(response[1]["Last-Modified"]) + 600)
  #   response[1]["Last-Modified"].must_equal now
  # end
end

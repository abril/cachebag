require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

describe CacheBag::HttpEntry do
  
  it "should have basic http properties" do
    @entry = CacheBag::HttpEntry.new("http://www.example.com", {"Content-Type" => "text/html"}, "<p>awesome example</p>")
    
    @entry.url.must_equal "http://www.example.com"
    @entry.headers["Content-Type"].must_equal "text/html"
    @entry.body.must_equal "<p>awesome example</p>"
  end
  
  it "should return the parsed last modified header" do
    now = Time.parse(Time.now.httpdate)
    @entry = CacheBag::HttpEntry.new("http://www.example.com", { "Last-Modified" => now.httpdate }, "<p>awesome example</p>")
    
    @entry.last_modified.must_equal now
  end
  
  it "should return the parsed etag header" do
    @entry = CacheBag::HttpEntry.new("http://www.example.com", { "ETag" => md5("<p>awesome example</p>").inspect }, "<p>awesome example</p>")
    
    @entry.etag.must_equal md5("<p>awesome example</p>").inspect
  end
    
  it "should return the parsed age header" do
    now = Time.parse(Time.now.httpdate)
    @entry = CacheBag::HttpEntry.new("http://www.example.com", { "Date" => now.httpdate, "Last-Modified" => (now - 600).httpdate }, "<p>awesome example</p>")
    
    @entry.age(now).must_equal 600
  end
end

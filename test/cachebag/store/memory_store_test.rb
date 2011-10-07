require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe CacheBag::MemoryStore do
  before do
    @memory_store = CacheBag::MemoryStore.new
  end

  it "should read and write an entry" do
    @memory_store.write("http://www.example.com", {"Content-Type" => "text/html"}, "<p>awesome example</p>")
    
    entry = @memory_store.read("http://www.example.com")
    entry.headers["Content-Type"].must_equal "text/html"
    entry.body.must_equal "<p>awesome example</p>"
  end
    
  it "should delete an entry" do
    @memory_store.write("http://www.example.com", {"Content-Type" => "text/html"}, "<p>awesome example</p>")
    
    entry = @memory_store.delete("http://www.example.com")
    entry.headers["Content-Type"].must_equal "text/html"
    entry.body.must_equal "<p>awesome example</p>"
    
    entry = @memory_store.delete("http://www.example.com")
    entry.must_be_nil
  end
  
  it "should clear all store" do
    @memory_store.write("http://www.example.com", {"Content-Type" => "text/html"}, "<p>awesome example</p>")
    
    entry = @memory_store.clear
    entry = @memory_store.read("http://www.example.com")
    entry.must_be_nil
  end
  
end

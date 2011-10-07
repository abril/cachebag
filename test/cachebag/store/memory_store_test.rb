require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

describe CacheBag::MemoryStore do
  before do
    @memory_store = CacheBag::MemoryStore.new
  end

  it "should write an entry" do
    @memory_store.write("http://www.example.com")
    
    entry = @memory_store.read("http://www.example.com")
    entry[:headers].must_equal({})
    entry[:body].must_be_nil
  end
  
  it "should read an entry" do
    @memory_store.write("http://www.example.com")
    
    entry = @memory_store.read("http://www.example.com")
    entry[:headers].must_equal({})
    entry[:body].must_be_nil
  end
  
  it "should delete an entry" do
    @memory_store.write("http://www.example.com")
    
    entry = @memory_store.delete("http://www.example.com")
    entry[:headers].must_equal({})
    entry[:body].must_be_nil
    entry = @memory_store.delete("http://www.example.com")
    entry.must_be_nil
  end
  
  it "should clear all store" do
    @memory_store.write("http://www.example.com")
    
    entry = @memory_store.clear
    entry = @memory_store.read("http://www.example.com")
    entry.must_be_nil
  end
  
end

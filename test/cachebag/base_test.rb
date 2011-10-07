require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

describe CacheBag::Base do
  before do
    #@store = CacheBag::Store.new
  end
  
  it "should instantiate with memory store by default" do
    cache = CacheBag::Base.new
    
    cache.store.must_be_kind_of CacheBag::MemoryStore
  end
end

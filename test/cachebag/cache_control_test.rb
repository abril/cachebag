# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

# Check http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9 for the spec of Cache-Control header

describe CacheBag::CacheControl do
  
  it "should instantiate a new cache-control header" do
    cc = CacheBag::CacheControl.new("max-age=600,must-revalidate")
    
    cc.must_be_kind_of(CacheBag::CacheControl)
    cc.value.must_equal(CacheBag::CacheControl.new("must-revalidate, max-age=600").value)
  end
  
  it "should accept empty declarations" do
    cc = CacheBag::CacheControl.new("")
    
    cc.value.must_equal("")
    cc.no_cache?.must_equal(false)
  end
  
  it "should accept one-directive declaration" do
    cc = CacheBag::CacheControl.new("no-cache")
    
    cc.no_cache?.must_equal(true)
  end
  
  it "should accept multi-directive declaration" do
    cc = CacheBag::CacheControl.new("no-cache, max-age=600, private = \"Accept\"")
    
    cc.no_cache?.must_equal(true)
    cc.max_age?.must_equal(true)
    cc.max_age.must_equal(600)
    cc.private.must_equal("Accept")
  end
  
  it "should accept standalone directives" do
    cc = CacheBag::CacheControl.new("no-cache, public")
    
    cc.public?.must_equal(true)
    cc.public.must_be_nil
  end
  
  it "should accept directive with integer value" do
    cc = CacheBag::CacheControl.new("max-age=600")
    
    cc.max_age?.must_equal(true)
    cc.max_age.must_equal(600)
  end

  it "should accept directive with string value" do
    cc = CacheBag::CacheControl.new("private=Accept, no-cache=\"Content-Type\"")
    
    cc.private?.must_equal(true)
    cc.private.must_equal("Accept")    
    cc.no_cache?.must_equal(true)
    cc.no_cache.must_equal("Content-Type")
  end
  
  it "should accept extension directives" do
    cc = CacheBag::CacheControl.new("private, community=\"UCI\", stand-alone-extension")
    
    cc.private?.must_equal(true)
    cc.private.must_be_nil
    cc.community?.must_equal(true)
    cc.community.must_equal("UCI")
    cc.stand_alone_extension?.must_equal(true)
  end
  
  it "should exposes the directives hash" do
    cc = CacheBag::CacheControl.new("private, community=\"UCI\", stand-alone-extension")
    
    cc.directives.must_be_kind_of(Hash)
    cc.directives[:community].must_equal("UCI")
    cc.directives.key?(:private).must_equal(true)
  end
  
  it "should be able to add a directive" do
    cc = CacheBag::CacheControl.new("private, community=\"UCI\", stand-alone-extension")
    
    cc.max_age?.must_equal(false)
    cc.directives[:max_age] = 800
    cc.max_age?.must_equal(true)
    cc.max_age.must_equal(800)
  end
end
